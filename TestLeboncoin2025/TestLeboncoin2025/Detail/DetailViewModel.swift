//
//  DetailViewModel.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

final class DetailViewModel {
    weak var coordinator: DetailViewControllerDelegate?
    private let itemViewModel: ItemViewModel
    
    init(with itemViewModel: ItemViewModel) {
        self.itemViewModel = itemViewModel
    }
}
