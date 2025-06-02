//
//  CachedImageView.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 21/05/2025.
//
import UIKit

@MainActor final class CachedImageView: UIImageView {
    // Le cache est commun à toutes les instances.
    private static let imageCache = NSCache<NSURL, UIImage>()
    private var imageLoadTask: Task<Void, Never>?

    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // Dans le cas où il n'y a pas de dimensions précises à fournir d'entrée
    convenience init() {
        self.init(frame: .zero)
        setupSpinner()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinner()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSpinner()
    }
    
    // La vue de chargement
    private func setupSpinner() {
        addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func loadImage(from url: URL, placeholder: String) {
        imageLoadTask?.cancel()
        self.image = UIImage(named: placeholder)
        
        // Si l'image est déjà en cache, inutile de solliciter le réseau.
        if let cachedImage = Self.imageCache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }

        spinner.startAnimating()

        // Téléchargement de l'image
        imageLoadTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else {
                    return
                }

                if let image = UIImage(data: data) {
                    Self.imageCache.setObject(image, forKey: url as NSURL)

                    // Animation en fondu
                    UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        self.image = image
                    }, completion: nil)
                }
            } catch {
                if !Task.isCancelled {
                    print("❌ Image loading error: \(error.localizedDescription)")
                }
            }

            spinner.stopAnimating()
        }
    }

    // Pour optimiser les performances, on annule la tâche de téléchargement si la vue concernée n'est pas visible.
    func prepareForReuse() {
        imageLoadTask?.cancel()
        self.image = nil
        spinner.stopAnimating()
    }
}
