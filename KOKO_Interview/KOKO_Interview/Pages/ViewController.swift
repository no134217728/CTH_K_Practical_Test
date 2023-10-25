//
//  ViewController.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func noFriend(_ sender: Any) {
        let viewModel = FriendsViewModel()
        viewModel.inputs.setTheCase(theCase: .NoFriends)
        
        let viewController = FriendsViewController(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onlyFriends(_ sender: Any) {
        let viewModel = FriendsViewModel()
        viewModel.inputs.setTheCase(theCase: .Friends)
        
        let viewController = FriendsViewController(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func friendsInvitation(_ sender: Any) {
        let viewModel = FriendsViewModel()
        viewModel.inputs.setTheCase(theCase: .WithInvitations)
        
        let viewController = FriendsViewController(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

enum Sceniaro {
    case NoFriends
    case Friends
    case WithInvitations
}

extension UITableView {
    func dequeueBaseCell<T: UITableViewCell>(class name: T.Type, for indexPath: IndexPath, configure value: BaseCellModelProtocol) -> T {
        guard let baseCell = dequeueReusableCell(withIdentifier: String(describing: name), 
                                                 for: indexPath) as? BaseCell else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        
        baseCell.configureWith(cellModel: value)
        
        guard let cell = baseCell as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name))")
        }
        
        return cell
    }
    
    func registerWith(cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: String(describing: cell))
    }
}
