//
//  SessionListViewController.swift
//  BatChat
//
//  Created by Hanson on 2021/5/28.
//

import UIKit

class SessionListViewController: BaseViewController {
    lazy var viewModel = SessionListViewModel(navigator: DefaultSessionNavigator(navigator: navigationController as! NavigationController))

    lazy var tableView: UITableView = getTabelView()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        bindViewModel()
    }

    // MARK: - setupUI

    private func setupNav() {
        navBar.title = "聊天"
        navBar.titleLabel.textColor = .white
        navBar.setRightButton(image: "icon_nav_add_white".image!)
        addNavBackColor(left: "#00B6B3".color, right: "#0FE7C3".color)
        
        navBar.onRightButtonClick = { [weak self] in
            guard let button = self?.navBar.rightButton else { return }
            
            let list = SessionPopView.sessionCreatList()
            SessionPopView.show(button, dataSource: list, corner: .bottomLeft, tx: -8) {[weak self] index in
                let vc = BCSessionViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    // MARK: - bind

    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        tableView.mj_header = MJRefreshNormalHeader()
        let pull = tableView.mj_header!.rx.refreshing.asDriver()
        let selection = tableView.rx.itemSelected.asDriver()
        let cellAction = tableView.rx.itemAccessoryButtonTapped.asDriver()
        
        let input = SessionListViewModel.Input(
            trigger: Driver.merge(viewWillAppear, pull),
            selection: selection, tap: cellAction)
        let output = viewModel.transform(input: input)

        output.fetching
            .drive(tableView.mj_header!.rx.endRefreshing)
            .disposed(by: disposeBag)

        output.list.drive(
            tableView.rx.items(
                cellIdentifier: SessionListCell.reuseID,
                cellType: SessionListCell.self)) {
            _, viewModel, cell in

            cell.bind(data: viewModel)

        }.disposed(by: disposeBag)
    }
}

// MARK: - configureView

extension SessionListViewController {
    private func configureTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 105
    }

    fileprivate func getTabelView() -> UITableView {
        let tableView = TableViewFactory.create()
        tableView.registerClassOf(SessionListCell.self)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navBottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        return tableView
    }
}
