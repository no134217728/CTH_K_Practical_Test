//
//  FriendsViewModel.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import Foundation

protocol FriendsViewModelInput {
    func setTheCase(theCase: Sceniaros)
}

protocol FriendsViewModelOutput {
    var theCase: Sceniaros { get }
}

protocol FriendsViewModelType {
    var inputs: FriendsViewModelInput { get }
    var outputs: FriendsViewModelOutput { get }
}

class FriendsViewModel: FriendsViewModelType, FriendsViewModelInput, FriendsViewModelOutput {
    var inputs: FriendsViewModelInput { self }
    var outputs: FriendsViewModelOutput { self }
    
    var theCase: Sceniaros = .NoFriends
    
    func setTheCase(theCase: Sceniaros) {
        self.theCase = theCase
    }
}
