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
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .medium
        spinner.transform = CGAffineTransform(scaleX: Constants.List.spinnerScale, y: Constants.List.spinnerScale)
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        buildViewHierarchy()
        setConstraints()
        setBindings()
        setNavigationBar()
        
        viewModel?.fetchItemList()
    }
    
    private func buildViewHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(itemCollectionView)
        view.addSubview(loadingSpinner)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
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
    
    // Attention à être explicite en mettant bien @MainActor en premier dans la closure.
    private func setBindings() {
        viewModel?.onDataUpdated = { @MainActor [weak self] in
            print("Data update")
            self?.itemCollectionView.reloadData()
        }
        
        viewModel?.isLoadingData = { @MainActor [weak self] isLoading in
            print("Loading data: \(isLoading)")
            self?.setLoadingSpinner(isLoading: isLoading)
        }
    }
}

extension ListViewController {
    private func setNavigationBar() {
        let onClickSourceButton = UIAction(title: "") { [weak self] action in
            self?.viewModel?.goToFilterView()
        }
        
        navigationItem.title = "Liste des articles"
        let navItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), primaryAction: onClickSourceButton)
        navigationItem.rightBarButtonItem = navItem
        navigationController?.navigationBar.tintColor = .label
        
        // For UI testing
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "listButton"
    }
    
    private func setLoadingSpinner(isLoading: Bool) {
        if isLoading {
            loadingSpinner.startAnimating()
        } else {
            loadingSpinner.stopAnimating()
        }
    }
}

extension ListViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Items disponibles: \(viewModel?.numberOfItems() ?? 0)")
        return viewModel?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell, let itemViewModel = viewModel?.getItemViewModel(at: indexPath) else {
            fatalError("Failed to dequeue ItemCollectionViewCell")
        }
        cell.configure(with: itemViewModel)
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.goToDetailView(selectedViewModelIndex: indexPath.item)
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            // Gestion des colonnes si c'est sur iPad ou iPhone
            let iPad = environment.traitCollection.userInterfaceIdiom == .pad
            let columns = iPad ? 4 : 2
            let spacing: CGFloat = Constants.List.spacing
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
            section.contentInsets = NSDirectionalEdgeInsets(top: Constants.List.insets, leading: Constants.List.insets, bottom: Constants.List.insets, trailing: Constants.List.insets)
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
        viewModel?.searchQuery = ""
        searchBar.text = ""
        itemCollectionView.reloadData()
        self.searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchQuery = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// Pour prévisualiser en direct et créer les vues plus rapidement
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
