//
//  BCHomeViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/2/3.
//

import UIKit

final class BCHomeViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
    }
    
    private let navigator: BCHomeNavigator
    init(navigator: BCHomeNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: BCHomeViewModel.Input) -> BCHomeViewModel.Output {
        return BCHomeViewModel.Output()
    }
}
