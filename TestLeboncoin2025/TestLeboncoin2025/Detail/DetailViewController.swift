//
//  DetailViewController.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel?
    
    private lazy var productImage: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "productImage" // Pour les tests UI
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var isUrgentLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.specialLabel, weight: .semibold)
        )
        label.adjustsFontForContentSizeCategory = true
        label.backgroundColor = .systemOrange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.Detail.urgentRadius
        label.paddingBottom = 7
        label.paddingTop = 7
        label.accessibilityIdentifier = "urgentLabel"
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.accessibilityIdentifier = "scrollView"
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.itemTitle, weight: .semibold)
        )
        label.textColor = .label
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productTitle" // Pour les tests UI
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.price, weight: .semibold)
        )
        label.numberOfLines = 1
        label.sizeToFit()
        label.textColor = .green
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productPrice" // Pour les tests UI
        return label
    }()
    
    private lazy var postedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.contentLabel, weight: .semibold)
        )
        label.numberOfLines = 0
        label.textColor = .label
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productDate" // Pour les tests UI
        return label
    }()
    
    private lazy var productDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.titleLabel, weight: .semibold)
        )
        label.numberOfLines = 0
        label.textColor = .label
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productDescriptionTitleLabel"
        return label
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.contentLabel, weight: .medium)
        )
        label.numberOfLines = 0
        label.textColor = .label
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "productDescription" // Pour les tests UI
        return label
    }()
    
    private lazy var professionalSellerTitleLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "PRO"
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.specialLabel, weight: .semibold)
        )
        label.textColor = .white
        label.backgroundColor = .blue
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.Detail.proRadius
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "professionalSellerTitleLabel"
        return label
    }()
    
    private lazy var professionalSellerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: UIFont.systemFont(ofSize: Constants.Detail.contentLabel, weight: .medium)
        )
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "productPro" // Pour les tests UI
        return label
    }()
    
    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemYellow
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var proStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Il faut explicitement définir la couleur de fond pour une transition fluide et propre. Autrement, le rendu de transition ne sera pas fluide.
        view.backgroundColor = .systemBackground
        setNavigationBar()
        buildViewHierarchy()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    // ATTENTION: Cette fonction se déclenche lorsque l'écran est détruit et lorsqu'un écran va au-dessus de celui-ci.
    override func viewWillDisappear(_ animated: Bool) {
        // On s'assure d'éviter toute fuite mémoire (memory leak) en détruisant correctement l'instance du coordinator. Le dépilage du ViewController est déjà géré par le NavigationController, inutile d'ajouter des instructions supplémentaires.
        if isMovingFromParent {
            viewModel?.backToPreviousScreen()
        }
    }
    
    private func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(productImage)
        contentView.addSubview(itemContentView)
        itemContentView.addSubview(productTitleLabel)
        itemContentView.addSubview(productPriceLabel)
        itemContentView.addSubview(postedDateLabel)
        
        if let itemViewModel = viewModel, itemViewModel.isUrgentItem() {
            itemContentView.addSubview(isUrgentLabel)
        }
        
        contentView.addSubview(productDescriptionTitleLabel)
        contentView.addSubview(productDescriptionLabel)
        
        if let itemViewModel = viewModel, itemViewModel.isProfessionalSeller() {
            contentView.addSubview(proStackView)
            proStackView.addArrangedSubview(professionalSellerTitleLabel)
            proStackView.addArrangedSubview(professionalSellerLabel)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor, multiplier: 0.75)
        ])
        
        NSLayoutConstraint.activate([
            itemContentView.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: Constants.Detail.contentViewTopMargin),
            itemContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
            itemContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin),
        ])
        
        NSLayoutConstraint.activate([
            productTitleLabel.topAnchor.constraint(equalTo: itemContentView.topAnchor, constant: Constants.Detail.contentViewVerticalMargin),
            productTitleLabel.leadingAnchor.constraint(equalTo: itemContentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
            productTitleLabel.trailingAnchor.constraint(equalTo: itemContentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin)
        ])
        
        NSLayoutConstraint.activate([
            productPriceLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 10),
            productPriceLabel.leadingAnchor.constraint(equalTo: itemContentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
            productPriceLabel.trailingAnchor.constraint(equalTo: itemContentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin)
        ])
        
        NSLayoutConstraint.activate([
            postedDateLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 15),
            postedDateLabel.leadingAnchor.constraint(equalTo: itemContentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
            postedDateLabel.trailingAnchor.constraint(equalTo: itemContentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin)
        ])
        
        if let itemViewModel = viewModel, !itemViewModel.isUrgentItem() {
            NSLayoutConstraint.activate([
                postedDateLabel.bottomAnchor.constraint(equalTo: itemContentView.bottomAnchor, constant: -Constants.Detail.contentViewVerticalMargin)
            ])
        }
        
        // Si l'item à vendre et urgent ou s'il s'agit d'un vendeur professionnel, on affiche la section en bas.
        if let itemViewModel = viewModel, itemViewModel.isUrgentItem() {
            NSLayoutConstraint.activate([
                isUrgentLabel.widthAnchor.constraint(equalTo: itemContentView.widthAnchor, multiplier: 0.4),
                isUrgentLabel.topAnchor.constraint(equalTo: postedDateLabel.bottomAnchor, constant: 20),
                isUrgentLabel.leadingAnchor.constraint(equalTo: itemContentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
                isUrgentLabel.trailingAnchor.constraint(equalTo: itemContentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin),
                isUrgentLabel.bottomAnchor.constraint(equalTo: itemContentView.bottomAnchor, constant: -Constants.Detail.contentViewVerticalMargin)
            ])
        }
        
        NSLayoutConstraint.activate([
            productDescriptionTitleLabel.topAnchor.constraint(equalTo: itemContentView.bottomAnchor, constant: 30),
            productDescriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
            productDescriptionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin)
        ])
        
        NSLayoutConstraint.activate([
            productDescriptionLabel.topAnchor.constraint(equalTo: productDescriptionTitleLabel.bottomAnchor, constant: Constants.Detail.horizontalMargin),
            productDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin)
        ])
        
        if let itemViewModel = viewModel, !itemViewModel.isProfessionalSeller() {
            NSLayoutConstraint.activate([
                productDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
        
        if let itemViewModel = viewModel, itemViewModel.isProfessionalSeller() {
            NSLayoutConstraint.activate([
                professionalSellerTitleLabel.widthAnchor.constraint(equalTo: proStackView.widthAnchor, multiplier: 0.25),
                proStackView.topAnchor.constraint(equalTo: productDescriptionLabel.bottomAnchor, constant: 30),
                proStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Detail.horizontalMargin),
                proStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Detail.horizontalMargin),
                proStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
    }
    
    private func setData() {
        guard let itemViewModel = viewModel?.getItemViewModel() else {
            configureMockData()
            return
        }
        
        if let url = URL(string: itemViewModel.thumbImage) {
            // Téléchargement asynchrone de l'image
            productImage.loadImage(from: url, placeholder: "leboncoinPlaceholderThumb")
        } else {
            productImage.image = UIImage(resource: .leboncoinPlaceholderThumb)
        }
        
        productTitleLabel.text = itemViewModel.itemTitle
        productPriceLabel.text = formatPriceInEuros(with: itemViewModel.itemPrice)
        
        postedDateLabel.text = itemViewModel.itemAddedDate.stringToFullDateFormat()
        productDescriptionLabel.text = itemViewModel.itemDescription
        isUrgentLabel.text = "URGENT"
        
        if let siret = itemViewModel.siret {
            professionalSellerLabel.text = "N°SIRET: \(siret)"
        }
    }
    
    private func configureMockData() {
        productImage.loadImage(from: URL(string: "https://img-prd-pim.poorvika.com/prodvarval/Apple-iphone-16-pro-black-titanium-128gb-Front-Back-View-Thumbnail.png")!, placeholder: "leboncoinPlaceholderThumb")
        
        productTitleLabel.text = "iPhone 16 Pro 512 GB noir batterie neuve"
        productPriceLabel.text = "1 200€"
        
        postedDateLabel.text = "2025-05-18T20:13:31+0000".stringToFullDateFormat()
        productDescriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu."
    }
}

extension DetailViewController {
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = "Retour"
        
        // For UI testing
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "listButton"
    }
    
    // Dependency injection
    func configure(with viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
}

// Pour prévisualiser en direct et créer les vues plus rapidement
#if DEBUG
@available(iOS 17.0, *)
#Preview("DetailViewController preview") {
    let navigationController = UINavigationController()
    let builder = DetailModuleBuilder(itemViewModel: ItemViewModel.getFakeProUrgentItem())
    let vc = builder.buildModule(testMode: true)
    navigationController.pushViewController(vc, animated: false)
    return navigationController
}
#endif
