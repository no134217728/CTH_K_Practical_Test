//
//  FriendsViewController.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class FriendsViewController: BaseViewController {
    lazy var tableView: UITableView = {
        let table = UITableView()
        
        table.registerWith(cell: InvitationsCell.self)
        table.registerWith(cell: TabSwitchCell.self)
        table.registerWith(cell: SearchCell.self)
        table.registerWith(cell: FriendCell.self)
        table.separatorStyle = .none
        
        return table
    }()
    
    var viewModel: FriendsViewModelType
    
    init(viewModel: FriendsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") 
    }
    
    override func layoutSetup() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetup()
        bindViewModel()
        
        viewModel.inputs.loadConents()
        
        tableView.rx.contentOffset
            .subscribe { [unowned self] offset in
                print("offset: \(offset)")
                if offset.y < -100 {
                    self.refresh()
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.outputs.error
            .bind { err in
                print("error: \(err)")
            }.disposed(by: disposeBag)
        
        viewModel.outputs.items
            .drive(tableView.rx.items(dataSource: makeDataSource()))
            .disposed(by: disposeBag)
    }
    
    private func makeDataSource() -> RxTableViewSectionedReloadDataSource<MainSectionModel> {
        RxTableViewSectionedReloadDataSource<MainSectionModel> { _, tableView, indexPath, cellModel in
            let cell = tableView.dequeueBaseCell(class: cellModel.cellIdentifier, for: indexPath, configure: cellModel)
            
            return cell
        }
    }
    
    private func refresh() {
        print("refreshing")
        viewModel.inputs.loadConents()
    }
}
