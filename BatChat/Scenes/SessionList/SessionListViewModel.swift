//
//  SessionListViewModel.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

final class SessionListViewModel: ViewModelType {
    lazy var disposeBag = DisposeBag()
    private let useCase = netwokData.makeSessionUseCase()
    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<IndexPath>
        let tap: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let list: Driver<[SessionListCellVM]>
    }
    
    private let navigator: SessionListNavigator
    init(navigator: SessionListNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator =  BehaviorRelay<Bool>(value: false)
        let errorTracker = ErrorTracker()
        
        let list = input.trigger.flatMapLatest { page in
            self.useCase.sessionList()
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        }.map {
            $0.map { SessionListCellVM(with: $0) }
        }
        
        input.selection.withLatestFrom(list) {
            (indexPath, list) -> SessionListCellVM in
            return list[indexPath.row]
        }
        .do(onNext:navigator.toSession)
        .drive()
        .disposed(by: disposeBag)
        
        input.tap.withLatestFrom(list) {
            (indexPath, list) -> SessionListCellVM in
            return list[indexPath.row]
        }
        .do(onNext:navigator.toSession)
        .drive()
        .disposed(by: disposeBag)
        
        return Output(fetching: activityIndicator.asDriver(),
                      list: list)
    }
}
