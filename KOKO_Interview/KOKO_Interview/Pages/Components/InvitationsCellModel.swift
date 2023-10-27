//
//  InvitationsCellModel.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit

class InvitationsCellModel: BaseCellModel {
    override var cellIdentifier: UITableViewCell.Type { InvitationsCell.self }
    
    var friend: Friend
    
    init(friend: Friend) {
        self.friend = friend
    }
}
