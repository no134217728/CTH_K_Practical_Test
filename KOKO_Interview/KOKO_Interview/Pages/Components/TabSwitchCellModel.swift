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
    var selectedIndex: Int = 0
    
    init(tabs: [String]) {
        self.tabs = tabs
    }
}
