//
//  InvitationsCell.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class InvitationsCell: BaseCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0.1)
        view.layer.shadowRadius = 16
        
        return view
    }()
    
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
        
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        label.text = "邀請你成為好友：）"
        
        return label
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "btnFriendsAgree"), for: .normal)
        
        return button
    }()
    
    private lazy var noButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "btnFriendsDelet"), for: .normal)
        
        return button
    }()
    
    var yesAction: Driver<Void> { yesActionRelay.asDriver(onErrorJustReturn: ()) }
    var noAction: Driver<Void> { noActionRelay.asDriver(onErrorJustReturn: ()) }
    
    private let yesActionRelay: PublishRelay<Void> = .init()
    private let noActionRelay: PublishRelay<Void> = .init()
    
    override func layoutSetup() {
        super.layoutSetup()
        
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.bottom.equalToSuperview()
        }
        
        containerView.addSubview(headerImage)
        containerView.addSubview(nameLabel)
        containerView.addSubview(subTitle)
        containerView.addSubview(yesButton)
        containerView.addSubview(noButton)
        
        headerImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(headerImage.snp.trailing).offset(15)
            $0.top.equalToSuperview().offset(14)
            $0.height.equalTo(22)
        }
        
        subTitle.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.height.equalTo(18)
        }
        
        noButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        yesButton.snp.makeConstraints {
            $0.trailing.equalTo(noButton.snp.leading).offset(-15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
    }
    
    override func configureWith(cellModel: BaseCellModelProtocol) {
        guard let cellModel = cellModel as? InvitationsCellModel else { return }
        
        headerImage.image = UIImage(named: "imgFriendsList")
        nameLabel.text = cellModel.friend.name
    }
}
