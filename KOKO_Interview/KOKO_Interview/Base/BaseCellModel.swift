//
//  BaseCellModel.swift
//  Line_Bank_Sample
//
//  Created by Wei Jen Wang on 2023/6/12.
//

import Foundation
import UIKit

protocol BaseCellModelProtocol {
    var cellIdentifier: UITableViewCell.Type { get }
}

class BaseCellModel: BaseCellModelProtocol {
    var cellIdentifier: UITableViewCell.Type {
        BaseCell.self
    }
}
