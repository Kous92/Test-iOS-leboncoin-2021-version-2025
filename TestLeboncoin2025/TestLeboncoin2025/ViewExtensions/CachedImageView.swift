//
//  CachedImageView.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 21/05/2025.
//
import UIKit

@MainActor final class CachedImageView: UIImageView {
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

        if let cachedImage = Self.imageCache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }

        spinner.startAnimating()

        imageLoadTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }

                if let image = UIImage(data: data) {
                    Self.imageCache.setObject(image, forKey: url as NSURL)

                    // ⬇️ Fade-in animation
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

    func prepareForReuse() {
        imageLoadTask?.cancel()
        self.image = nil
        spinner.stopAnimating()
    }
}
