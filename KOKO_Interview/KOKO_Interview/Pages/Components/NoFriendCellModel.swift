//
//  NoFriendCellModel.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/26.
//

import UIKit

class NoFriendCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type { NoFriendCell.self }
    
    var mainTitle: String
    var subTitle: String
    var hint: String
    var hintHigh: String
    
    init(mainTitle: String, subTitle: String, hint: String, hintHigh: String) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.hint = hint
        self.hintHigh = hintHigh
    }
}
