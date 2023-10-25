//
//  FriendsViewModel.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import Foundation

import RxCocoa
import RxDataSources

protocol FriendsViewModelInput {
    func setTheCase(theCase: Sceniaro)
    func loadConents()
}

protocol FriendsViewModelOutput {
    var error: PublishRelay<Error> { get }
    var man: PublishRelay<Man> { get }
    var items: Driver<[MainSectionModel]> { get }
}

protocol FriendsViewModelType {
    var inputs: FriendsViewModelInput { get }
    var outputs: FriendsViewModelOutput { get }
}

class FriendsViewModel: FriendsViewModelType, FriendsViewModelInput, FriendsViewModelOutput {
    var inputs: FriendsViewModelInput { self }
    var outputs: FriendsViewModelOutput { self }
    
    let error: PublishRelay<Error> = .init()
    let man: PublishRelay<Man> = .init()
    var items: Driver<[MainSectionModel]> { itemsRelay.asDriver() }
    
    private let itemsRelay: BehaviorRelay<[MainSectionModel]> = .init(value: [])
    private var theCase: Sceniaro = .NoFriends
    private var friends: [Friend] = []
    
    func setTheCase(theCase: Sceniaro) {
        self.theCase = theCase
    }
    
    func loadConents() {
        makeCellModel()
    }
    
    private func makeCellModel() {
        var titleSectionModels: [BaseCellModel] = []
        var contentSectionModels: [BaseCellModel] = []
        
        let sections: [MainSectionModel] = [.titleSection(titleSectionModels), .contentSection(contentSectionModels)]
        
        itemsRelay.accept(sections)
    }
}

enum MainSectionModel: SectionModelType {
    case titleSection(_ cellModels: [BaseCellModelProtocol])
    case contentSection(_ cellModels: [BaseCellModelProtocol])
    
    var items: [BaseCellModelProtocol] {
        switch self {
        case let .titleSection(cellModels),
            let .contentSection(cellModels):
            return cellModels
        }
    }
    
    init(original: MainSectionModel, items: [BaseCellModelProtocol]) {
        self = original
    }
}
