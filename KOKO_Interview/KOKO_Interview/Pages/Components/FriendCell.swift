//
//  FriendCell.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FriendCell: BaseCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "icFriendsStar")
        
        return imageView
    }()
    
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
        
        return label
    }()
    
    private lazy var transferButton: ButtonWithInfo = {
        let button = ButtonWithInfo()
        
        button.setTitle("轉帳", for: .normal)
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor(red: 236.0/255.0, green: 0, blue: 140.0/255.0, alpha: 1).cgColor
        button.setTitleColor(UIColor(red: 236.0/255.0, green: 0, blue: 140.0/255.0, alpha: 1), for: .normal)
        
        return button
    }()
    
    private lazy var invitationButton: ButtonWithInfo = {
        let button = ButtonWithInfo()
        
        button.setTitle("邀請中", for: .normal)
        button.layer.borderWidth = 1.2
        button.layer.borderColor = UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 1).cgColor
        button.setTitleColor(UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 1), for: .normal)
        
        return button
    }()
    
    private lazy var dotButton: ButtonWithInfo = {
        let button = ButtonWithInfo()
        
        button.setImage(UIImage(named: "icFriendsMore"), for: .normal)
        
        return button
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1)
        
        return view
    }()
    
    var transferButtonTap: Driver<String> { transferButtonTapRelay.asDriver(onErrorJustReturn: "") }
    var invitingButtonTap: Driver<String> { invitingButtonTapRelay.asDriver(onErrorJustReturn: "") }
    var moreButtonTap: Driver<String> { moreButtonTapRelay.asDriver(onErrorJustReturn: "") }
    
    private let transferButtonTapRelay: PublishRelay<String> = .init()
    private let invitingButtonTapRelay: PublishRelay<String> = .init()
    private let moreButtonTapRelay: PublishRelay<String> = .init()
    
    override func layoutSetup() {
        super.layoutSetup()
        
        contentView.addSubview(containerView)
        contentView.addSubview(bottomLine)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
        
        containerView.addSubview(headerImage)
        containerView.addSubview(nameLabel)
        containerView.addSubview(transferButton)
        
        headerImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(headerImage.snp.trailing).offset(15)
            $0.centerY.equalTo(headerImage.snp.centerY)
        }
        
        bottomLine.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(18)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func configureWith(cellModel: BaseCellModelProtocol) {
        guard let cellModel = cellModel as? FriendCellModel else { return }
        
        headerImage.image = UIImage(named: "imgFriendsList")
        
        if cellModel.friend.isTop {
            containerView.addSubview(starImage)
            
            starImage.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(10)
                $0.centerY.equalToSuperview()
            }
        }
        
        switch cellModel.friend.status {
        case .inviting:
            containerView.addSubview(invitationButton)
            
            invitationButton.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.equalTo(60)
                $0.height.equalTo(24)
            }
            
            transferButton.snp.makeConstraints {
                $0.trailing.equalTo(invitationButton.snp.leading).offset(-10)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(47)
                $0.height.equalTo(24)
            }
            
            invitationButton.fid = cellModel.friend.fid
            transferButton.fid = cellModel.friend.fid
            invitationButton.addTarget(self, action: #selector(invitingClick(sender:)), for: .touchUpInside)
            transferButton.addTarget(self, action: #selector(transferClick(sender:)), for: .touchUpInside)
        case .complete:
            containerView.addSubview(dotButton)
            
            dotButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-10)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(18)
                $0.height.equalTo(4)
            }
            
            transferButton.snp.makeConstraints {
                $0.trailing.equalTo(dotButton.snp.leading).offset(-25)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(47)
                $0.height.equalTo(24)
            }
            
            dotButton.fid = cellModel.friend.fid
            transferButton.fid = cellModel.friend.fid
            dotButton.addTarget(self, action: #selector(moreClick(sender:)), for: .touchUpInside)
            transferButton.addTarget(self, action: #selector(transferClick(sender:)), for: .touchUpInside)
        case .sent: break
        }
        
        nameLabel.text = cellModel.friend.name
    }
    
    @objc private func transferClick(sender: ButtonWithInfo) {
        transferButtonTapRelay.accept(sender.fid)
    }
    
    @objc private func invitingClick(sender: ButtonWithInfo) {
        invitingButtonTapRelay.accept(sender.fid)
    }
    
    @objc private func moreClick(sender: ButtonWithInfo) {
        moreButtonTapRelay.accept(sender.fid)
    }
}
