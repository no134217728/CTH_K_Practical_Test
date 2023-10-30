//
//  FriendsViewModel.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

protocol FriendsViewModelInput {
    func setTheCase(theCase: Sceniaro)
    func loadConents()
    func nameSearch(name: String)
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
    
    let disposeBag = DisposeBag()
    
    let error: PublishRelay<Error> = .init()
    let man: PublishRelay<Man> = .init()
    var items: Driver<[MainSectionModel]> { itemsRelay.asDriver() }
    
    private let itemsRelay: BehaviorRelay<[MainSectionModel]> = .init(value: [])
    private let friendList1: PublishRelay<[Friend]> = .init()
    private let friendList2: PublishRelay<[Friend]> = .init()
    
    private var theCase: Sceniaro = .NoFriends
    private var friendInvitationList: [Friend] = []
    private var finalFriendList: [Friend] = []
    private var allFriendList: [Friend] = []
    private var filteredFriendList: [Friend] = []
    
    func setTheCase(theCase: Sceniaro) {
        self.theCase = theCase
    }
    
    func loadConents() {
        switch theCase {
        case .NoFriends:
            let requestURL = "https://dimanyen.github.io/friend4.json"
            APIService.shared.fetchObject(requestURL: requestURL, resModel: [Friend].self) { friends in
                for friend in friends {
                    switch friend.status {
                    case .sent:
                        self.friendInvitationList.append(friend)
                    case .inviting, .complete:
                        self.allFriendList.append(friend)
                    }
                }
                
                self.finalFriendList = self.allFriendList
                self.makeCellModel()
            } onError: { error in
                self.error.accept(error)
            }
        case .Friends:
            Observable.zip(friendList1, friendList2).subscribe { [weak self] friendList1, friendList2 in
                let allFriends: [Friend] = friendList1 + friendList2
                self?.allFriendList = allFriends.reduce([]) { (all, next) -> [Friend] in
                    if all.contains(where: { $0.fid == next.fid }) {
                        guard let theSame = all.first(where: { $0.fid == next.fid }) else { return all }
                        if theSame.updateDate > next.updateDate {
                            return all
                        } else {
                            var list = all
                            list.removeAll(where: { $0.fid == theSame.fid })
                            list.append(next)
                            return list
                        }
                    } else {
                        var list = all
                        list.append(next)
                        return list
                    }
                }
                
                self?.finalFriendList = self?.allFriendList ?? []
                self?.makeCellModel()
            }.disposed(by: disposeBag)
            
            let requestURL1 = "https://dimanyen.github.io/friend1.json"
            let requestURL2 = "https://dimanyen.github.io/friend2.json"
            APIService.shared.fetchObject(requestURL: requestURL1, resModel: [Friend].self) { friendList in
                self.friendList1.accept(friendList)
            } onError: { error in
                self.error.accept(error)
            }
            
            APIService.shared.fetchObject(requestURL: requestURL2, resModel: [Friend].self) { friendList in
                self.friendList2.accept(friendList)
            } onError: { error in
                self.error.accept(error)
            }
        case .WithInvitations:
            let requestURL = "https://dimanyen.github.io/friend3.json"
            APIService.shared.fetchObject(requestURL: requestURL, resModel: [Friend].self) { friendList in
                for friend in friendList {
                    switch friend.status {
                    case .sent:
                        self.friendInvitationList.append(friend)
                    case .inviting, .complete:
                        self.allFriendList.append(friend)
                    }
                }
                
                self.finalFriendList = self.allFriendList
                self.makeCellModel()
            } onError: { error in
                self.error.accept(error)
            }
        }
    }
    
    func nameSearch(name: String) {
        if !name.isEmpty {
            filteredFriendList = allFriendList.filter({ $0.name.contains(name) })
            finalFriendList = filteredFriendList
            makeCellModel()
        }
    }
    
    private func makeCellModel() {
        var contentSectionModels: [BaseCellModel] = []
        
        friendInvitationList.forEach { friend in
            contentSectionModels.append(InvitationsCellModel(friend: friend))
        }
        
        contentSectionModels.append(TabSwitchCellModel(tabs: ["好友", "聊天"]))
        
        if finalFriendList.isEmpty {
            contentSectionModels.append(NoFriendCellModel(mainTitle: "就從加好友開始吧：）",
                                                          subTitle: "與好友們一起用 KOKO 聯起來！\n還能互相收付款、發紅包呢：）",
                                                          hint: "幫助好友更快找到你？設定 KOKO ID",
                                                          hintHigh: "設定 KOKO ID"))
        } else {
            contentSectionModels.append(SearchCellModel(searchPlaceholder: "想轉一筆給誰呢？"))
            finalFriendList.forEach { friend in
                contentSectionModels.append(FriendCellModel(friend: friend))
            }
        }
        
        let sections: [MainSectionModel] = [.contentSection(contentSectionModels)]
        
        itemsRelay.accept(sections)
    }
}

class MockFriendsViewModel: FriendsViewModelType, FriendsViewModelInput, FriendsViewModelOutput {
    var inputs: FriendsViewModelInput { self }
    var outputs: FriendsViewModelOutput { self }
    
    let disposeBag = DisposeBag()
    
    let error: PublishRelay<Error> = .init()
    let man: PublishRelay<Man> = .init()
    var items: Driver<[MainSectionModel]> { itemsRelay.asDriver() }
    
    private let itemsRelay: BehaviorRelay<[MainSectionModel]> = .init(value: [])
    private let friendList1: PublishRelay<[Friend]> = .init()
    private let friendList2: PublishRelay<[Friend]> = .init()
    
    private var theCase: Sceniaro = .NoFriends
    private var friendInvitationList: [Friend] = []
    private var finalFriendList: [Friend] = []
    private var allFriendList: [Friend] = []
    private var filteredFriendList: [Friend] = []
    
    func setTheCase(theCase: Sceniaro) {
        self.theCase = theCase
    }
    
    func loadConents() {
        switch theCase {
        case .NoFriends:
            let fileName = "friend4"
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let paramsModel = try JSONDecoder().decode([Friend].self, from: data)
                    
                    for friend in paramsModel {
                        switch friend.status {
                        case .sent:
                            self.friendInvitationList.append(friend)
                        case .inviting, .complete:
                            self.finalFriendList.append(friend)
                        }
                    }
                    
                    self.makeCellModel()
                } catch {
                    print("file error: \(fileName), error: \(error)")
                }
            }
        case .Friends:
            Observable.zip(friendList1, friendList2).subscribe { [weak self] friendList1, friendList2 in
                let allFriends: [Friend] = friendList1 + friendList2
                self?.finalFriendList = allFriends.reduce([]) { (all, next) -> [Friend] in
                    if all.contains(where: { $0.fid == next.fid }) {
                        guard let theSame = all.first(where: { $0.fid == next.fid }) else { return all }
                        if theSame.updateDate > next.updateDate {
                            return all
                        } else {
                            var list = all
                            list.removeAll(where: { $0.fid == theSame.fid })
                            list.append(next)
                            return list
                        }
                    } else {
                        var list = all
                        list.append(next)
                        return list
                    }
                }
                
                self?.makeCellModel()
            }.disposed(by: disposeBag)
            
            let fileName = "friend1"
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let paramsModel = try JSONDecoder().decode([Friend].self, from: data)
                    
                    self.friendList1.accept(paramsModel)
                } catch {
                    print("file error: \(fileName), error: \(error)")
                }
            }
            
            let fileName2 = "friend2"
            if let path = Bundle.main.path(forResource: fileName2, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let paramsModel = try JSONDecoder().decode([Friend].self, from: data)
                    
                    self.friendList2.accept(paramsModel)
                } catch {
                    print("file error: \(fileName), error: \(error)")
                }
            }
        case .WithInvitations:
            let fileName = "friend3"
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let paramsModel = try JSONDecoder().decode([Friend].self, from: data)
                    
                    for friend in paramsModel {
                        switch friend.status {
                        case .sent:
                            self.friendInvitationList.append(friend)
                        case .inviting, .complete:
                            self.finalFriendList.append(friend)
                        }
                    }
                    
                    self.makeCellModel()
                } catch {
                    print("file error: \(fileName), error: \(error)")
                }
            }
        }
    }
    
    func nameSearch(name: String) {
        if !name.isEmpty {
            filteredFriendList = allFriendList.filter({ $0.name.contains(name) })
            finalFriendList = filteredFriendList
            makeCellModel()
        }
    }
    
    private func makeCellModel() {
        var contentSectionModels: [BaseCellModel] = []
        
        friendInvitationList.forEach { friend in
            contentSectionModels.append(InvitationsCellModel(friend: friend))
        }
        
        contentSectionModels.append(TabSwitchCellModel(tabs: ["好友", "聊天"]))
        
        if finalFriendList.isEmpty {
            contentSectionModels.append(NoFriendCellModel(mainTitle: "就從加好友開始吧：）",
                                                          subTitle: "與好友們一起用 KOKO 聯起來！\n還能互相收付款、發紅包呢：）",
                                                          hint: "幫助好友更快找到你？設定 KOKO ID",
                                                          hintHigh: "設定 KOKO ID"))
        } else {
            contentSectionModels.append(SearchCellModel(searchPlaceholder: "想轉一筆給誰呢？"))
            finalFriendList.forEach { friend in
                contentSectionModels.append(FriendCellModel(friend: friend))
            }
        }
        
        let sections: [MainSectionModel] = [.contentSection(contentSectionModels)]
        
        itemsRelay.accept(sections)
    }
}

enum MainSectionModel: SectionModelType {
    case contentSection(_ cellModels: [BaseCellModelProtocol])
    
    var items: [BaseCellModelProtocol] {
        switch self {
        case let .contentSection(cellModels):
            return cellModels
        }
    }
    
    init(original: MainSectionModel, items: [BaseCellModelProtocol]) {
        self = original
    }
}
