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
        RxTableViewSectionedReloadDataSource<MainSectionModel> { [weak self] _, tableView, indexPath, cellModel in
            let cell = tableView.dequeueBaseCell(class: cellModel.cellIdentifier, for: indexPath, configure: cellModel)
            
            if let tabCell = cell as? TabSwitchCell, let tabCellModel = cellModel as? TabSwitchCellModel {
                tabCell.tap.drive { [weak self] tag in
                    tabCellModel.selectedIndex = tag
                    self?.view.endEditing(true)
                }.disposed(by: tabCell.disposeBag)
            } else if let searchCell = cell as? SearchCell {
                searchCell.searchResult.drive { [weak self] search in
                    self?.viewModel.inputs.nameSearch(name: search)
                    self?.view.endEditing(true)
                }.disposed(by: searchCell.disposeBag)
            } else if let friendCell = cell as? FriendCell {
                friendCell.transferButtonTap.drive { [weak self] fid in
                    print("transferButtonTap: \(fid)")
                    self?.view.endEditing(true)
                }.disposed(by: friendCell.disposeBag)
                
                friendCell.invitingButtonTap.drive { [weak self] fid in
                    print("invitingButtonTap: \(fid)")
                    self?.view.endEditing(true)
                }.disposed(by: friendCell.disposeBag)
                
                friendCell.moreButtonTap.drive { [weak self] fid in
                    print("moreButtonTap: \(fid)")
                    self?.view.endEditing(true)
                }.disposed(by: friendCell.disposeBag)
            } else if let invitationCell = cell as? InvitationsCell {
                invitationCell.yesAction.drive { [weak self] fid in
                    print("yesAction: \(fid)")
                    self?.view.endEditing(true)
                }.disposed(by: invitationCell.disposeBag)
                
                invitationCell.noAction.drive { [weak self] fid in
                    print("noAction: \(fid)")
                    self?.view.endEditing(true)
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
