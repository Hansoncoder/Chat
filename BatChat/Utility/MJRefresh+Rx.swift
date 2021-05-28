//
//  MJRefresh+Rx.swift
//  forum
//
//  Created by Hanson on 2020/1/11.
//  Copyright © 2020 Hanson. All rights reserved.
//

import UIKit

///底部刷新结束状态
extension Reactive where Base: MJRefreshFooter {
    //正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    var endFooterRefreshing: Binder<RefreshFooterState> {
        return Binder(base) { refresh, endState in
            if endState == .noMoreData {
                refresh.endRefreshingWithNoMoreData()
            } else {
                refresh.endRefreshing()
            }
        }
    }
}

//对MJRefreshComponent增加rx扩展
extension Reactive where Base: MJRefreshComponent {
     
    //正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
     
    //停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}

public enum RefreshFooterState {
    case noMoreData, end
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: BehaviorRelay<Bool>) -> Observable<Element> {
        return self.asObservable()
            .do(onNext: { _ in
                activityIndicator.accept(true)
            }, onError: { _ in
                activityIndicator.accept(true)
            }, onCompleted: {
                activityIndicator.accept(true)
            })
    }
    
    public func trackMjFooterState(_ activityIndicator: BehaviorRelay<RefreshFooterState>) -> Observable<Element> {
        return self.asObservable()
            .do(onNext: { data in
                if let tmpArr = data as? Array<Element> {
                    if tmpArr.count == 0 {
                        //无数据
                        activityIndicator.accept(.noMoreData)
                    } else {
                        activityIndicator.accept(.end)
                    }
                } else {
                    activityIndicator.accept(.end)
                }
            }, onError: { data in
                activityIndicator.accept(.noMoreData)
            }, onCompleted: {
                activityIndicator.accept(.end)
            })
    }
}
