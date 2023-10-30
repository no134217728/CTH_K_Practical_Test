//
//  UserHeaderView.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import UIKit
import SnapKit

class UserHeaderView: UIView {
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1)
        
        return view
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
        
        return label
    }()
    
    private lazy var userIdLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
        
        return label
    }()
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 26
        
        return imageView
    }()
    
    private lazy var rightArrow: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "icInfoBackDeepGray")
        
        return imageView
    }()
    
    private lazy var redDot: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 236.0/255.0, green: 0.0/255.0, blue: 140.0/255.0, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.isHidden = true
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        layoutSetup()
        APIService.shared.fetchObject(requestURL: "https://dimanyen.github.io/man.json", resModel: [Man].self) { response in
            guard let first = response.first else {
                print("Man first error.")
                return
            }
            
            DispatchQueue.main.async {
                self.setupData(data: first)
            }
        } onError: { error in
            print("UserHeader Error: \(error)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutSetup() {
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
        
        containerView.addSubview(userNameLabel)
        containerView.addSubview(userIdLabel)
        containerView.addSubview(userImage)
        containerView.addSubview(rightArrow)
        containerView.addSubview(redDot)
        
        userIdLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(18)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userIdLabel.snp.leading)
            $0.bottom.equalTo(userIdLabel.snp.top).offset(-8)
        }
        
        userImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.height.equalTo(52)
        }
        
        rightArrow.snp.makeConstraints {
            $0.leading.equalTo(userIdLabel.snp.trailing)
            $0.centerY.equalTo(userIdLabel.snp.centerY)
        }
        
        redDot.snp.makeConstraints {
            $0.leading.equalTo(rightArrow.snp.trailing).offset(15)
            $0.centerY.equalTo(rightArrow.snp.centerY)
            $0.width.height.equalTo(10)
        }
    }
    
    private func setupData(data: Man) {
        userNameLabel.text = data.name
        userImage.image = UIImage(named: "imgFriendsFemaleDefault")
        
        if data.kokoid.isEmpty {
            userIdLabel.text = "設定 KOKO ID"
            redDot.isHidden = false
        } else {
            userIdLabel.text = "KOKO ID：\(data.kokoid)"
        }
    }
}
