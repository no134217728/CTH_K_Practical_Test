//
//  SearchCellModel.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit

class SearchCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type { SearchCell.self }
    
    var searchPlaceholder: String
    
    init(searchPlaceholder: String) {
        self.searchPlaceholder = searchPlaceholder
    }
}
