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
        table.registerWith(cell: NoFriendCell.self)
        table.registerWith(cell: SearchCell.self)
        table.registerWith(cell: FriendCell.self)
        table.separatorStyle = .none
        table.delegate = self
        
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        
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
        let barButtonATM = UIBarButtonItem(image: UIImage(named: "icNavPinkWithdraw"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(goBack))
        
        let barButtonDollar = UIBarButtonItem(image: UIImage(named: "icNavPinkTransfer"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(keyboardDismiss))
        
        let barButtonScan = UIBarButtonItem(image: UIImage(named: "icNavPinkScan"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(keyboardDismiss))
        
        navigationItem.leftBarButtonItems = [barButtonATM, barButtonDollar]
        navigationItem.rightBarButtonItem = barButtonScan
        
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
            
            if let tabCell = cell as? TabSwitchCell, let tabCellModel = cellModel as? TabSwitchCellModel {
                tabCell.tap.drive { tag in
                    tabCellModel.selectedIndex = tag
                }.disposed(by: tabCell.disposeBag)
            } else if let searchCell = cell as? SearchCell {
                searchCell.searchResult.drive { [weak self] search in
                    self?.viewModel.inputs.nameSearch(name: search)
                }.disposed(by: searchCell.disposeBag)
            } else if let friendCell = cell as? FriendCell {
                friendCell.transferButtonTap.drive { fid in
                    print("transferButtonTap: \(fid)")
                }.disposed(by: friendCell.disposeBag)
                
                friendCell.invitingButtonTap.drive { fid in
                    print("invitingButtonTap: \(fid)")
                }.disposed(by: friendCell.disposeBag)
                
                friendCell.moreButtonTap.drive { fid in
                    print("moreButtonTap: \(fid)")
                }.disposed(by: friendCell.disposeBag)
            } else if let invitationCell = cell as? InvitationsCell {
                invitationCell.yesAction.drive { fid in
                    print("yesAction: \(fid)")
                }.disposed(by: invitationCell.disposeBag)
                
                invitationCell.noAction.drive { fid in
                    print("noAction: \(fid)")
                }.disposed(by: invitationCell.disposeBag)
            }
            
            return cell
        }
    }
    
    private func refresh() {
        viewModel.inputs.loadConents()
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardDismiss() {
        view.endEditing(true)
    }
}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UserHeaderView()
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 100 : 0
    }
}
