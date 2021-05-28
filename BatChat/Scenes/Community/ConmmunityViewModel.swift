//
//  ConmmunityViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

final class ConmmunityViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
    }
    
    private let navigator: ConmmunityNavigator
    init(navigator: ConmmunityNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: ConmmunityViewModel.Input) -> ConmmunityViewModel.Output {
        return ConmmunityViewModel.Output()
    }
}
