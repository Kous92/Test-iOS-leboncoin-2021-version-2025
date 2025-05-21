//
//  FilterViewController.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import UIKit

final class FilterViewController: UIViewController {
    
    var viewModel: FilterViewModel?

    
    private var actualSelectedIndex = UserDefaults.standard.integer(forKey: "selectedCategory") // 0 si aucun paramètre sauvegardé
    private var selectedCategory = "Toutes catégories"
    
    private lazy var closeButton: UIButton = {
        // Préciser le type .system, sinon l'action au tap ne fonctionnera pas.
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(onCloseTap(sender:)), for: .touchUpInside)
        button.accessibilityIdentifier = "filterCloseButton" // Pour les tests UI
        return button
    }()
    
    private lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Catégories"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 1
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "categoryTitle" // Pour les tests UI
        return label
    }()
    
    private lazy var categoryTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // table.separatorStyle = .none
        table.accessibilityIdentifier = "filterTableView" // Pour les tests UI
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        setViews()
    }
    
    private func setViews() {
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(categoryTitleLabel)
        categoryTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        categoryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        categoryTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        view.addSubview(categoryTableView)
        categoryTableView.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: 20).isActive = true
        categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        categoryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    @objc func onCloseTap(sender: UIButton!) {
        // C'est dans la méthode implémentée dans MainViewController que la page va se fermer et ainsi récupérer les données, d'où l'utilité de la délégation
        // filterDelegate?.filterItemCategory(itemCategory: selectedCategory)
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // cell.textLabel?.text = viewModel?.categories[indexPath.row].name
        cell.tintColor = .systemGreen
        
        if indexPath.row == actualSelectedIndex {
            cell.accessoryType = .checkmark
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
        if selected == actualSelectedIndex {
            return
        }
        
        // Suppression du coche de l'ancienne cellule sélectionnée
        if let previousCell = tableView.cellForRow(at: IndexPath(row: actualSelectedIndex, section: indexPath.section)) {
            previousCell.accessoryType = .none
        }
        
        // On marque la cellule nouvellement sélectionnée avec un coche
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        // On garde en mémoire la catégorie séléctionnée
        actualSelectedIndex = selected
        
        // On garde en mémoire la catégorie séléctionnée
        // selectedCategory = viewModel?.categories[indexPath.row].name ?? ""
        
        // On sauvegarde la catégorie sélectionnée
        UserDefaults.standard.set(selected, forKey: "selectedCategory")
    }
}

// Ready to live preview and make views much faster
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct FilterViewControllerPreview: PreviewProvider {
    static var previews: some View {
        
        ForEach(deviceNames, id: \.self) { deviceName in
            // Dark mode
            UIViewControllerPreview {
                let navigationController = UINavigationController()
                let builder = FilterModuleBuilder()
                let vc = builder.buildModule(testMode: true)
                navigationController.pushViewController(vc, animated: false)
                
                return navigationController
            }
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .preferredColorScheme(.light)
            .previewDisplayName(deviceName)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#endif
