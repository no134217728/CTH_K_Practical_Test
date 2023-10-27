//
//  TabSwitchCellModel.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit

class TabSwitchCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type { TabSwitchCell.self }
    
    var tabs: [String]
    var selectedIndex: Int
    
    init(tabs: [String], selectedIndex: Int) {
        self.tabs = tabs
        self.selectedIndex = selectedIndex
    }
}
