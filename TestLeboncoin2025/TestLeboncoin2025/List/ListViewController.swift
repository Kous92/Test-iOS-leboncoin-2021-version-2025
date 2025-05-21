//
//  ListViewController.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 14/05/2025.
//

import UIKit

final class ListViewController: UIViewController {
    
    var viewModel: ListViewModel?
    
    private lazy var itemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // Pour la recherche des articles
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annuler"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
        searchBar.accessibilityIdentifier = "searchBar"
        searchBar.placeholder = "Rechercher..."
        
        return searchBar
    }()
    
    private var itemsVm: [ItemViewModel] = ItemViewModel.getFakeItems()
    private var filteredItemsVm: [ItemViewModel] = []
    
    private var searchTask: Task<Void, Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        filteredItemsVm = itemsVm
        
        buildViewHierarchy()
        setConstraints()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(itemCollectionView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            itemCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ListViewController {
    
}

extension ListViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Items disponibles: \(filteredItemsVm.count)")
        return filteredItemsVm.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Failed to dequeue ItemCollectionViewCell")
        }
        cell.configure(with: filteredItemsVm[indexPath.item])
        return cell
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            // Gestion des colonnes si c'est sur iPad ou iPhone
            let iPad = environment.traitCollection.userInterfaceIdiom == .pad
            let columns = iPad ? 4 : 2
            let spacing: CGFloat = 8
            let fractionalWidth = 1.0 / CGFloat(columns)
            
            // Taille de l'item = 100% du "groupe vertical"
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(320))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Groupe vertical contenant 1 item
            let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidth), heightDimension: .estimated(320))
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [item])
            
            // Groupe horizontal contenant N groupes verticaux (les colonnes)
            let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(320))
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: Array(repeating: verticalGroup, count: columns))
            horizontalGroup.interItemSpacing = .fixed(spacing)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = spacing
            
            return section
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredItemsVm = itemsVm
        searchBar.text = ""
        itemCollectionView.reloadData()
        self.searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self = self else { return }
            // Debounce: attendre 300 ms
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            // Si la tâche a été annulée entre-temps, ne rien faire
            guard !Task.isCancelled else { return }
            
            // Appliquer le filtre
            await MainActor.run {
                if searchText.isEmpty {
                    filteredItemsVm = itemsVm
                } else {
                    filteredItemsVm = itemsVm.filter { viewModel in
                        let title = viewModel.itemTitle.lowercased()
                        return title.contains(searchText.lowercased())
                    }
                }
                self.itemCollectionView.reloadData()
            }
        }
        */
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// Ready to live preview and make views much faster
#if DEBUG
@available(iOS 17.0, *)
#Preview("ListViewController preview") {
    let navigationController = UINavigationController()
    let builder = ListModuleBuilder()
    let vc = builder.buildModule(testMode: true)
    navigationController.pushViewController(vc, animated: false)
    
    return navigationController
}
#endif
