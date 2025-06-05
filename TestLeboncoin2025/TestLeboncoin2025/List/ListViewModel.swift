//
//  ListViewModel.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 14/05/2025.
//

import Foundation

@MainActor final class ListViewModel {
    // Delegate vers le Coordinator associée à la vue
    weak var coordinator: ListViewControllerDelegate?
    
    // Data binding: liaison entre la vue et la vue modèle: avec Swift 6 et une classe non isolée, la fonction doit être Sendable et dans le MainActor
    var onDataUpdated: (@Sendable @MainActor () -> Void)?
    var isLoadingData: (@Sendable @MainActor (_ loading: Bool) -> Void)?
    
    // Use cases
    private let itemCategoryFetchUseCase: ItemCategoryFetchUseCaseProtocol
    private let itemListFetchUseCase: ItemListFetchUseCaseProtocol
    
    // La liste des articles
    nonisolated(unsafe) private var itemsViewModels: [ItemViewModel] = []
    nonisolated(unsafe) private var filteredItemsViewModels: [ItemViewModel] = []
    nonisolated(unsafe) private var itemCategoriesViewModels: [ItemCategoryViewModel] = []
    
    // La tâche de recherche
    private var searchTask: Task<Void, Never>?
    private var searchQueryContinuation: AsyncStream<String>.Continuation?
    private var searchQueryTask: Task<Void, Never>?
    var searchQuery = "" {
        didSet {
            // À chaque modification du texte de recherche, yield va envoyer la nouvelle valeur
            searchQueryContinuation?.yield(searchQuery)
        }
    }
    
    // C'est ici qu'on injecte les dépendances des couches métiers et données de la Clean Architecture
    init(itemCategoryFetchUseCase: ItemCategoryFetchUseCaseProtocol, itemListFetchUseCase: ItemListFetchUseCaseProtocol) {
        self.itemCategoryFetchUseCase = itemCategoryFetchUseCase
        self.itemListFetchUseCase = itemListFetchUseCase
        // L'écoute du flux asynchrone de recherche est initialisé
        observeSearchQuery()
        print("ListViewModel initialisé.")
    }
    
    // Si l'objet est détruit, alors la tâche asynchrone de recherche doit être stoppée
    deinit {
        searchQueryTask?.cancel()
        searchQueryContinuation?.finish()
    }
    
    // Ici, on va récupérer depuis le réseau de façon synchronisée les catégories d'articles et les annonces
    nonisolated func fetchItemList() {
        print("Thread avant entrée dans le Task: ", Thread.currentThread)
        
        // On est toujours dans le MainActor
        Task.detached { [weak self] in
            guard let self else { return }
            
            print("Thread dans le Task avant màj: ", Thread.currentThread)
            print("Main Thread: \(Thread.isOnMainThread)")
            await self.isLoadingData?(true)
            
            await self.fetchItems()
            await self.fetchItemCategories()
            
            await self.isLoadingData?(false)
            print("Thread dans le Task après màj: ", Thread.currentThread)
            await self.onDataUpdated?()
        }
    }
    
    private func observeSearchQuery() {
        print("Observe search...")
        let stream = AsyncStream<String> { continuation in
            self.searchQueryContinuation = continuation
        }
        
        searchQueryTask = Task.detached { [weak self] in
            guard let self else { return }
            
            var lastValue: String? = nil
            
            for await query in stream {
                print("Thread Task search \(Thread.currentThread)")
                print("Query: \(await self.searchQuery)")
                // Ignore les doublons
                guard query != lastValue else { continue }
                lastValue = query
                
                // Debounce 300 ms
                try? await Task.sleep(for: .milliseconds(300))
                
                // Ignore si la valeur n’a pas changé pendant le délai
                guard await lastValue == searchQuery else {
                    continue
                }
                
                // Filtrage de la liste de recherche
                await filterItems()
            }
        }
    }
    
    private func filterItems() async {
        print("Filter items...")
        if searchQuery.isEmpty {
            filteredItemsViewModels = itemsViewModels
        } else {
            filteredItemsViewModels = itemsViewModels.filter { viewModel in
                let title = viewModel.itemTitle.lowercased()
                return title.contains(searchQuery.lowercased())
            }
        }
        
        await MainActor.run { [weak self] in
            self?.onDataUpdated?()
        }
    }
    
    nonisolated private func fetchItemCategories() async {
        print("Thread fetchItemCategories: \(Thread.currentThread)")
        
        do {
            itemCategoriesViewModels = try await itemCategoryFetchUseCase.execute()
        } catch APIError.errorMessage(let errorMessage) {
            await sendErrorMessage(with: errorMessage)
        } catch {
            await sendErrorMessage(with: error.localizedDescription)
        }
    }
    
    nonisolated private func fetchItems() async {
        print("Thread fetchItems: \(Thread.currentThread)")
        do {
            itemsViewModels = try await itemListFetchUseCase.execute()
        } catch APIError.errorMessage(let errorMessage) {
            await sendErrorMessage(with: errorMessage)
        } catch {
            await sendErrorMessage(with: error.localizedDescription)
        }
        
        filteredItemsViewModels = itemsViewModels
    }
    
    private func parseViewModels() async {
        // itemsViewModels = articleViewModels.map { $0.getNewsCellViewModel() }
    }
    
    // MARK: - Logique CollectionView
    func numberOfItems() -> Int {
        return filteredItemsViewModels.count
    }
    
    func getItemViewModel(at indexPath: IndexPath) -> ItemViewModel? {
        // On vérifie bien qu'il y a au moins une cellule dans la liste après filtrage, sinon ça il y aura un crash
        let cellCount = filteredItemsViewModels.count
        
        guard cellCount > 0, indexPath.item <= cellCount else {
            return nil
        }
        
        return filteredItemsViewModels[indexPath.item]
    }
}

// MARK: - Partie de navigation. Étant donné que cela est géré par le Coordinator et en lien avec la vue via le NavigationController, les fonctions doivent être isolées dans le MainActor (le main thread).
extension ListViewModel {
    private func sendErrorMessage(with errorMessage: String) {
        print(errorMessage)
        coordinator?.displayErrorAlert(with: errorMessage)
    }
    
    func goToDetailView(selectedViewModelIndex: Int) {
        coordinator?.goToDetailView(with: filteredItemsViewModels[selectedViewModelIndex])
    }
    
    func goToFilterView() {
        coordinator?.goToFilterView()
    }
}
