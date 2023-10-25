//
//  BaseCell.swift
//  Line_Bank_Sample
//
//  Created by Wei Jen Wang on 2023/6/12.
//

import UIKit

import RxSwift
import RxCocoa

class BaseCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    
    func layoutSetup() {
        self.selectionStyle = .none
    }
    
    func configureWith(cellModel: BaseCellModelProtocol) {
        
    }
}
