//
//  SearchCell.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchCell: BaseCell {
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        
        search.searchBarStyle = .minimal
        
        return search
    }()
    
    private lazy var addFriend: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "icBtnAddFriends"), for: .normal)
        
        return button
    }()
    
    var searchResult: Driver<String> { searchResultRelay.asDriver(onErrorJustReturn: "") }
    
    private let searchResultRelay: PublishRelay<String> = .init()
    
    override func layoutSetup() {
        super.layoutSetup()
        
        contentView.addSubview(searchBar)
        contentView.addSubview(addFriend)
        
        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        addFriend.snp.makeConstraints {
            $0.leading.equalTo(searchBar.snp.trailing).offset(15)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-30)
        }
    }
    
    override func configureWith(cellModel: BaseCellModelProtocol) {
        guard let cellModel = cellModel as? SearchCellModel else { return }
        
        searchBar.placeholder = cellModel.searchPlaceholder
    }
    
    override func additionalSetup() {
        searchBar.rx.text
            .orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] ele in
                self?.searchResultRelay.accept(ele.element ?? "")
            }.disposed(by: disposeBag)
    }
}
