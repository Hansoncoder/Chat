//
//  ContactViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

final class ContactViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
    }
    
    private let navigator: ContactNavigator
    init(navigator: ContactNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: ContactViewModel.Input) -> ContactViewModel.Output {
        return ContactViewModel.Output()
    }
}
