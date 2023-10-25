//
//  SearchCell.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit

class SearchCell: BaseCell {
    override func layoutSetup() {
        super.layoutSetup()
        
    }
    
    override func configureWith(cellModel: BaseCellModelProtocol) {
        guard let cellModel = cellModel as? SearchCellModel else { return }
    }
}
