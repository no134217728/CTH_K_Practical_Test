//
//  FriendsViewController.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class FriendsViewController: BaseViewController {
    var viewModel: FriendsViewModelType
    
    init(viewModel: FriendsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
