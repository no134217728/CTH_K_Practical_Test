//
//  TabSwitcherCell.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TabSwitchCell: BaseCell {
    private lazy var selectedBar: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 236.0/255.0, green: 0, blue: 140.0/255.0, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
        
        return view
    }()
    
    var tap: Driver<Int> { tapRelay.asDriver(onErrorJustReturn: 999) }
    private let tapRelay: PublishRelay<Int> = .init()
    
    private var tabLabels: [UILabel] = []
    
    override func layoutSetup() {
        super.layoutSetup()
        
        backgroundColor = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1)
        
        contentView.addSubview(selectedBar)
        contentView.addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func configureWith(cellModel: BaseCellModelProtocol) {
        guard let cellModel = cellModel as? TabSwitchCellModel else { return }
        
        tabLabels = []
        for tab in cellModel.tabs.enumerated() {
            let tabLabel: UILabel = {
                let label = UILabel()
                
                label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                label.textColor = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
                label.text = tab.element
                
                return label
            }()
            
            let tabButton: UIButton = {
                let button = UIButton()
                
                button.tag = tab.offset
                
                return button
            }()
            
            contentView.addSubview(tabLabel)
            contentView.addSubview(tabButton)
            tabLabels.append(tabLabel)
            
            if tab.offset == 0 {
                tabLabel.snp.makeConstraints {
                    $0.leading.equalToSuperview().offset(32)
                    $0.top.equalToSuperview().offset(9)
                    $0.bottom.equalToSuperview().offset(-9)
                    $0.height.equalTo(18)
                }
            } else {
                tabLabel.snp.makeConstraints {
                    $0.leading.equalTo(tabLabels[tab.offset - 1].snp.trailing).offset(36)
                    $0.top.equalToSuperview().offset(9)
                    $0.bottom.equalToSuperview().offset(-9)
                    $0.height.equalTo(18)
                }
            }
            
            tabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalTo(tabLabel)
            }
            
            tabButton.rx.tap.bind { [unowned tabButton, weak self] _ in
                guard let selectedTab = self?.tabLabels[tabButton.tag] else { return }
                
                UIView.animate(withDuration: 1) {
                    self?.selectedBar.snp.remakeConstraints {
                        $0.centerX.equalTo(selectedTab.snp.centerX)
                        $0.bottom.equalToSuperview()
                        $0.height.equalTo(4)
                        $0.width.equalTo(20)
                    }
                }
                
                self?.tapRelay.accept(tabButton.tag)
            }.disposed(by: disposeBag)
        }
        
        let selectedTab = tabLabels[cellModel.selectedIndex]
        selectedBar.snp.remakeConstraints {
            $0.centerX.equalTo(selectedTab.snp.centerX)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(4)
            $0.width.equalTo(20)
        }
    }
}
