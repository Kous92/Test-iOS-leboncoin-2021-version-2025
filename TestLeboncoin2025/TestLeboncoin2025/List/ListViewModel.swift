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
    
    // Data binding: liaison entre la vue et la vue modèle: avec Swift 6 et dans un contexte non isolé (nonisolated), la fonction doit être Sendable et dans le MainActor
    var onDataUpdated: (@Sendable @MainActor () -> Void)?
    var isLoadingData: (@Sendable @MainActor (_ loading: Bool) -> Void)?
    
    // Use cases
    private let itemCategoryFetchUseCase: ItemCategoryFetchUseCaseProtocol
    private let itemListFetchUseCase: ItemListFetchUseCaseProtocol
    private let loadSavedSelectedSourceUseCase: LoadSavedSelectedCategoryUseCaseProtocol
    
    // La liste des articles et des catégories. ATTENTION: l'usage de nonisolated(unsafe) est utilisé pour les variables qui peuvent être modifiées dans le temps dans un contexte asynchrone (en dehors du @MainActor), mais surtout à n'utiliser que depuis une seule tâche et donc une seule instance. Autrement, un crash de l'appli peut se déclencher si plusieurs tâches concurrentes sont sur ces variables, d'où le data race.
    nonisolated(unsafe) private var itemsViewModels: [ItemViewModel] = []
    nonisolated(unsafe) private var filteredItemsViewModels: [ItemViewModel] = []
    nonisolated(unsafe) private var itemCategoriesViewModels: [ItemCategoryViewModel] = []
    
    private var activeCategory = "Toutes catégories"
    
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
    init(itemCategoryFetchUseCase: ItemCategoryFetchUseCaseProtocol, itemListFetchUseCase: ItemListFetchUseCaseProtocol, loadSavedSelectedSourceUseCase: LoadSavedSelectedCategoryUseCaseProtocol) {
        self.itemCategoryFetchUseCase = itemCategoryFetchUseCase
        self.itemListFetchUseCase = itemListFetchUseCase
        self.loadSavedSelectedSourceUseCase = loadSavedSelectedSourceUseCase
        
        // L'écoute du flux asynchrone de recherche est initialisé
        observeSearchQuery()
        print("ListViewModel initialisé.")
    }
    
    // Si l'objet est détruit, alors la tâche asynchrone de recherche doit être stoppée
    deinit {
        searchQueryTask?.cancel()
        searchQueryContinuation?.finish()
    }
    
    // Dès qu'il y a eu une sélection du filtre depuis FilterViewController, se déclenche via les delegates de FilterCoordinator et ListCoordinator. Le but étant de charger le nouveau filtre et l'appliquer dès que nécessaire pour éviter certains bugs et soucis de synchronisation.
    nonisolated func updateCategoryFilter() {
        loadSelectedItemCategory()
    }
    
    // Ici, on va récupérer depuis le réseau de façon synchronisée les catégories d'articles et les annonces
    nonisolated func fetchItemList() {
        print("Thread avant entrée dans le Task: ", Thread.currentThread)
        
        // Task.detached permet de sortir du main thread et de passer en background thread (tâche de fond)
        Task.detached { [weak self] in
            guard let self else { return }
            
            print("Thread dans le Task avant màj: ", Thread.currentThread)
            print("Main Thread: \(Thread.isOnMainThread)")
            await self.isLoadingData?(true)
            
            // Les catégories en premier puis la liste d'annonces
            await self.fetchItemCategories()
            print("-> \(self.itemCategoriesViewModels)")
            await self.fetchItems()
            
            // Pour éviter un bug, l'actualisation de la vue se déclenchera après chargement de la catégorie et du filtrage.
            self.loadSelectedItemCategory()
            print("Thread dans le Task après màj: ", Thread.currentThread)
        }
    }
    
    nonisolated func loadSelectedItemCategory() {
        Task.detached { [weak self] in
            do {
                let itemCategory = try await self?.loadSavedSelectedSourceUseCase.execute()
                
                await MainActor.run { [weak self] in
                    self?.activeCategory = itemCategory?.name ?? "Toutes catégories"
                }
                
                await self?.filterItemsByCategory(with: itemCategory?.name ?? "Toutes catégories")
            } catch APIError.errorMessage(let message) {
                print("\(message). La catégorie par défaut sera appliquée.")
                await self?.filterItemsByCategory(with: "Toutes catégories")
            }
        }
    }
    
    private func observeSearchQuery() {
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
                await filterItemsWithSearch()
            }
        }
    }
    
    private func filterItemsWithSearch() async {
        if searchQuery.isEmpty {
            filteredItemsViewModels = itemsViewModels
        } else {
            filteredItemsViewModels = itemsViewModels.filter { viewModel in
                let title = viewModel.itemTitle.lowercased()
                return title.contains(searchQuery.lowercased())
            }
        }
        
        // Il faut conserver le filtre de catégorie s'il est mis en application (excepté le générique)
        if activeCategory != "Toutes catégories" {
            filteredItemsViewModels = filteredItemsViewModels.filter { itemViewModel in
                return itemViewModel.itemCategory == activeCategory
            }
        }
        
        await MainActor.run { [weak self] in
            self?.isLoadingData?(false)
            self?.onDataUpdated?()
        }
    }
    
    private func filterItemsByCategory(with itemCategoryName: String) async {
        if itemCategoryName == "Toutes catégories" {
            filteredItemsViewModels = itemsViewModels
        } else {
            filteredItemsViewModels = itemsViewModels.filter { viewModel in
                // Attention à un bug: Si un filtrage par recherche est déjà actif, il faut le prendre en compte.
                let matchingCategory = viewModel.itemCategory == itemCategoryName
                
                // print(">>> Filtrage de catégories avec recherche: \(!searchQuery.isEmpty)")
                if !searchQuery.isEmpty {
                    let title = viewModel.itemTitle.lowercased()
                    return title.contains(searchQuery.lowercased()) && matchingCategory
                }
                
                return matchingCategory
            }
        }
        
        await MainActor.run { [weak self] in
            self?.isLoadingData?(false)
            self?.onDataUpdated?()
        }
    }
    
    nonisolated private func fetchItemCategories() async {
        print("Thread fetchItemCategories: \(Thread.currentThread)")
        
        do {
            // On va ajouter en plus des catégories téléchargées, une catégorie générique qui n'aura aucun filtre
            itemCategoriesViewModels.append(ItemCategoryViewModel(id: 0, name: "Toutes catégories"))
            itemCategoriesViewModels += try await itemCategoryFetchUseCase.execute()
        } catch APIError.errorMessage(let errorMessage) {
            await sendErrorMessage(with: errorMessage)
        } catch {
            await sendErrorMessage(with: error.localizedDescription)
        }
    }
    
    nonisolated private func fetchItems() async {
        print("Thread fetchItems: \(Thread.currentThread)")
        do {
            await parseViewModels(with: try await itemListFetchUseCase.execute())
        } catch APIError.errorMessage(let errorMessage) {
            await sendErrorMessage(with: errorMessage)
        } catch {
            await sendErrorMessage(with: error.localizedDescription)
        }
        
        filteredItemsViewModels = itemsViewModels
    }
    
    private func parseViewModels(with itemsViewModels: [ItemViewModel]) async {
        self.itemsViewModels = itemsViewModels.map { item in
            let categoryId = self.itemCategoriesViewModels.firstIndex { category in
                guard let id = Int(item.itemCategory) else {
                    return false
                }
                
                return id == category.id
            }
            
            var category = "Inconnu"
            
            if let categoryId {
                category = self.itemCategoriesViewModels[categoryId].name
            }
            
            return ItemViewModel(smallImage: item.smallImage, thumbImage: item.thumbImage, itemTitle: item.itemTitle, itemCategory: category, itemPrice: item.itemPrice, isUrgent: item.isUrgent, itemDescription: item.itemDescription, itemAddedDate: item.itemAddedDate, siret: item.siret)
        }
    }
    
    // MARK: - Logique CollectionView
    func numberOfItems() -> Int {
        return filteredItemsViewModels.count
    }
    
    func getItemViewModel(at indexPath: IndexPath) -> ItemViewModel? {
        // On vérifie bien qu'il y a au moins une cellule dans la liste après filtrage, sinon ça il y aura un crash
        let cellCount = filteredItemsViewModels.count
        
        guard cellCount > 0, indexPath.item < cellCount else {
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
        coordinator?.goToFilterView(with: itemCategoriesViewModels)
    }
}
