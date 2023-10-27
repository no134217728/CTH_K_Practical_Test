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
    
    var tap: Driver<Void> { tapRelay.asDriver(onErrorJustReturn: ()) }
    private let tapRelay: PublishRelay<Void> = .init()
    
    private var tabLabels: [UILabel] = []
    
    override func layoutSetup() {
        super.layoutSetup()
        
        addSubview(selectedBar)
        addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func configureWith(cellModel: BaseCellModelProtocol) {
        guard let cellModel = cellModel as? TabSwitchCellModel else { return }
        
        tabLabels = []
        for tab in cellModel.tabs.enumerated() {
            var tabLabel: UILabel = {
                let label = UILabel()
                
                label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                label.textColor = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
                label.text = tab.element
                
                return label
            }()
            
            var tabButton: UIButton = {
                let button = UIButton()
                
                button.tag = tab.offset
                
                return button
            }()
            
            addSubview(tabLabel)
            addSubview(tabButton)
            if tab.offset == 0 {
                tabLabel.snp.makeConstraints {
                    $0.leading.equalToSuperview().offset(32)
                    $0.top.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-10)
                    $0.height.equalTo(18)
                }
            } else {
                tabLabel.snp.makeConstraints {
                    $0.leading.equalTo(tabLabels[tab.offset].snp.trailing).offset(36)
                    $0.top.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-10)
                    $0.height.equalTo(18)
                }
            }
            
            tabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalTo(tabLabel)
            }
            
            tabButton.addTarget(self, action: #selector(tabClicked(sender:)), for: .touchUpInside)
            tabLabels.append(tabLabel)
        }
    }
    
    @objc private func tabClicked(sender: UIButton) {
        let selectedTab = tabLabels[sender.tag]
        UIView.animate(withDuration: 1) {
            self.selectedBar.snp.remakeConstraints {
                $0.centerX.equalTo(selectedTab.snp.centerX)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(4)
            }
        }
        
        tapRelay.accept(())
    }
}
