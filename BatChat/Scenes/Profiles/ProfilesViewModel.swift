//
//  ProfilesViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

final class ProfilesViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
    }
    
    private let navigator: ProfilesNavigator
    init(navigator: ProfilesNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: ProfilesViewModel.Input) -> ProfilesViewModel.Output {
        return ProfilesViewModel.Output()
    }
}
