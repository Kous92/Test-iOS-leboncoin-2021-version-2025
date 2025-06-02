//
//  ItemCollectionViewCell.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 17/05/2025.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"
    
    var viewModel = ItemViewModel()
    private var isUrgent: Bool = false
    
    private lazy var itemImage: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .label
        label.minimumScaleFactor = 0.5
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: 14, weight: .semibold)
        )
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private lazy var itemCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.minimumScaleFactor = 0.5
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: 11, weight: .medium)
        )
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.minimumScaleFactor = 0.5
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: 14, weight: .semibold)
        )
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private lazy var itemUrgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: 12, weight: .semibold)
        )
        label.adjustsFontForContentSizeCategory = true
        label.backgroundColor = .orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Ici on va positionner les éléments dans la vue de la cellule (ici contentView)
        buildViewHierarchy(isUrgent: true)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // À chaque fois qu'une cellule est réutilisée (lors du scroll), cela sera utile pour avoir la bonne image à l'index associé
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImage.prepareForReuse() // ✅ Annule toute tâche de chargement en cours
        itemImage.image = nil
        itemLabel.text = nil
        itemCategoryLabel.text = nil
        itemPriceLabel.text = nil
        itemUrgentLabel.text = nil
    }
    
    private func buildViewHierarchy(isUrgent: Bool) {
        contentView.addSubview(itemImage)
        contentView.addSubview(itemLabel)
        
        contentView.addSubview(itemPriceLabel)
        
        if isUrgent {
            contentView.addSubview(itemUrgentLabel)
        }
        
        contentView.addSubview(itemCategoryLabel)
    }
    
    private func setConstraints() {
        // Ajout des contraintes: Auto Layout par code
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(itemImage.heightAnchor.constraint(equalTo: itemImage.widthAnchor, multiplier: 0.75))
        constraints.append(itemImage.topAnchor.constraint(equalTo: contentView.topAnchor))
        constraints.append(itemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(itemImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        // Contraintes titre de l'item
        constraints.append(itemLabel.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: 10))
        constraints.append(itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        // Contraintes prix de l'item
        constraints.append(itemPriceLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 6))
        constraints.append(itemPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(itemPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        // Contraintes catégorie de l'item
        constraints.append(itemCategoryLabel.topAnchor.constraint(equalTo: itemPriceLabel.bottomAnchor, constant: 10))
        constraints.append(itemCategoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
        constraints.append(itemCategoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        // Contraintes urgence item (dans l'image)
        if contentView.subviews.contains(itemUrgentLabel) {
            constraints.append(itemUrgentLabel.topAnchor.constraint(equalTo: itemCategoryLabel.bottomAnchor, constant: 5))
            constraints.append(itemUrgentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor))
            constraints.append(itemUrgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
            constraints.append(itemUrgentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8))
        }
        
        // Application des contraintes définies
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with viewModel: ItemViewModel) {
        let price = formatPriceInEuros(with: viewModel.itemPrice)
        
        self.viewModel = viewModel
        itemLabel.text = viewModel.itemTitle
        itemCategoryLabel.text = viewModel.itemCategory
        itemPriceLabel.text = price
        itemUrgentLabel.text = viewModel.isUrgent ? "URGENT" : "NON URGENT"
        itemUrgentLabel.isHidden = viewModel.isUrgent ? false : true
        
        if let url = URL(string: viewModel.image) {
            // Téléchargement asynchrone de l'image
            itemImage.loadImage(from: url, placeholder: "noImage")
        } else {
            itemImage.image = UIImage(named: "noImage")
        }
        
        // Pour l'accessibilité et le support de VoiceOver
        itemLabel.accessibilityLabel = "Titre de l'annonce"
        itemLabel.accessibilityValue = viewModel.itemTitle
        
        itemCategoryLabel.accessibilityLabel = "Catégorie"
        itemCategoryLabel.accessibilityValue = viewModel.itemCategory
        
        itemPriceLabel.accessibilityLabel = "Prix"
        itemPriceLabel.accessibilityValue = price
        
        itemUrgentLabel.accessibilityLabel = "Urgence"
        itemUrgentLabel.accessibilityValue = viewModel.isUrgent ? "Urgent" : "Non urgent"
        
        itemImage.isAccessibilityElement = true
        itemImage.accessibilityLabel = "Image de l'annonce"
    }
}

// Ready to live preview and make views much faster
#if DEBUG
@available(iOS 17.0, *)
#Preview("ItemCollectionViewCell preview", traits: .fixedLayout(width: 180, height: 300)) {
    let view = ItemCollectionViewCell()
    view.configure(with: ItemViewModel.getFakeItem())
    
    return view
}
#endif
