//
//  FilterViewController.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import UIKit

final class FilterViewController: UIViewController {
    
    var viewModel: FilterViewModel?
    
    private lazy var categoryTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // table.separatorStyle = .none
        table.accessibilityIdentifier = "filterTableView" // Pour les tests UI
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewHierarchy()
        setConstraints()
        setNavigationBar()
        setBindings()
        
        viewModel?.loadSetting()
    }
    
    // WARNING: This function is triggered when the screen is destroyed and when a screen will go above this one.
    override func viewWillDisappear(_ animated: Bool) {
        // We make sure to avoid any memory leak by destroying correctly the coordinator instance. Popping ViewController is already done with NavigationController, no need to add extra instruction.
        if isMovingFromParent {
            viewModel?.backToPreviousScreen()
        }
    }
    
    private func buildViewHierarchy() {
        view.addSubview(categoryTableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: view.topAnchor),
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // Attention à être explicite en mettant bien @MainActor en premier dans la closure.
    private func setBindings() {
        viewModel?.onDataUpdated = { @MainActor [weak self] in
            print("Liste des catégories à jour")
            self?.categoryTableView.reloadData()
        }
    }
}

extension FilterViewController {
    private func setNavigationBar() {
        navigationItem.title = "Catégories"
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = "Retour"
        
        // For UI testing
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "listButton"
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let itemViewModel = viewModel?.getItemCategoryViewModel(at: indexPath), let currentSelectedIndex = viewModel?.getCurrentSelectedIndex() else {
            fatalError("Failed to dequeue TableViewCell")
        }
        
        cell.textLabel?.text = itemViewModel.name
        cell.tintColor = .systemGreen
        
        print("\(indexPath.row) : \(currentSelectedIndex)")
        if indexPath.row == currentSelectedIndex {
            print("check")
            cell.accessoryType = .checkmark
        } else {
            // En cas de bug, utile pour forcer la cohérence
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Désélectionner la ligne.
        categoryTableView.deselectRow(at: indexPath, animated: false)
        
        // L'utilisateur a-t-il tapé sur un cellule déjà sélectionnée ? Si c'est le cas, ne rien faire.
        let selected = indexPath.row
        let currentSelectedIndex = viewModel?.getCurrentSelectedIndex() ?? 0
        print(currentSelectedIndex)
        
        // L'utilisateur a-t-il tapé sur un élément sélectionné. Si c'est le cas, ne rien faire
        if selected == currentSelectedIndex {
            return
        }
        
        // Suppression du coche de l'ancienne cellule sélectionnée
        if let previousCell = tableView.cellForRow(at: IndexPath(row: currentSelectedIndex, section: indexPath.section)) {
            previousCell.accessoryType = .none
        }
        
        // On marque la cellule nouvellement sélectionnée avec un coche
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        // On sauvegarde la catégorie sélectionnée
        viewModel?.saveSelectedCategory(at: indexPath)
        print(viewModel?.getCurrentSelectedIndex() ?? -1)
    }
}

// Pour prévisualiser en direct et créer les vues plus rapidement
#if DEBUG
@available(iOS 17.0, *)
#Preview("FilterViewController preview") {
    let navigationController = UINavigationController()
    let builder = FilterModuleBuilder(with: ItemCategoryViewModel.getFakeItemCategories())
    let vc = builder.buildModule(testMode: true)
    navigationController.pushViewController(vc, animated: false)
    
    return navigationController
}
#endif
