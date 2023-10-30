//
//  NoFriendCell.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/26.
//

import UIKit

class NoFriendCell: BaseCell {
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "imgFriendsEmpty")
        
        return imageView
    }()
    
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        label.textColor = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 1)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var addFriendButton: UIButton = {
        let button = UIButton()
        
        let gradient = CAGradientLayer()
        gradient.frame = button.bounds
        gradient.colors = [UIColor(red: 86.0/255.0, green: 179.0/255.0, blue: 11.0/255.0, alpha: 1),
                           UIColor(red: 166.0/255.0, green: 204.0/255.0, blue: 66.0/255.0, alpha: 1)]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        button.layer.insertSublayer(gradient, at: 0)
        
        return button
    }()
    
    private lazy var bottomHint: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        label.textAlignment = .center
        
        return label
    }()
    
    override func layoutSetup() {
        super.layoutSetup()
        
        contentView.addSubview(mainImage)
        contentView.addSubview(mainTitle)
        contentView.addSubview(subTitle)
        contentView.addSubview(addFriendButton)
        contentView.addSubview(bottomHint)
        
        mainImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(65)
            $0.top.equalToSuperview().offset(30)
        }
        
        mainTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(44)
            $0.top.equalTo(mainImage.snp.bottom).offset(41)
        }
        
        subTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(67)
            $0.top.equalTo(mainTitle.snp.bottom).offset(8)
        }
        
        addFriendButton.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(192)
            $0.height.equalTo(40)
        }
        
        bottomHint.snp.makeConstraints {
            $0.top.equalTo(addFriendButton.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(43)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    override func configureWith(cellModel: BaseCellModelProtocol) {
        guard let cellModel = cellModel as? NoFriendCellModel else { return }
        
        mainTitle.text = cellModel.mainTitle
        subTitle.text = cellModel.subTitle
        bottomHint.attributedText = hintHighLight(hintText: cellModel.hint,
                                                  highText: cellModel.hintHigh)
        
    }
    
    private func hintHighLight(hintText: String, highText: String) -> NSMutableAttributedString {
        let hotPink = UIColor(red: 236.0/255.0, green: 0, blue: 140.0/255.0, alpha: 1)
        let attributedString = NSMutableAttributedString(string: hintText)
        let range = (hintText as NSString).range(of: highText)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        attributedString.addAttribute(.foregroundColor, value: hotPink, range: range)
        
        return attributedString
    }
}
