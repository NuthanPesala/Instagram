//
//  UsersProfileTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 18/05/21.
//

import UIKit

protocol  UsersProfileTableViewCellDelegate: AnyObject {
    func UsersProfileTableViewCellDidTapFollowbtn(model: UserRealtionship)
}

enum UserFollowState {
    case following, not_following
}

struct UserRealtionship {
    let name: String
    let userName: String
    let type: UserFollowState
}

class UsersProfileTableViewCell: UITableViewCell {
    
    static let identifier: String = "UsersProfileTableViewCell"
    
    public weak var delegate: UsersProfileTableViewCellDelegate? = nil
    
    var model: UserRealtionship?
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Nuthan"
        label.numberOfLines = 1
        return label
    }()
    
    let userNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.text = "@raju_pesala"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    let followBtn: UIButton = {
       let btn = UIButton()
        btn.clipsToBounds = true
        btn.setTitle("Follow", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = UIColor.link
        btn.layer.borderWidth = 1
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(userNameLabel)
        addSubview(followBtn)
        followBtn.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        let buttonWidth = contentView.width > 500 ? 220 : contentView.width / 3
        followBtn.frame = CGRect(x: contentView.width - 5 - buttonWidth, y: (contentView.height - 40) / 2, width: buttonWidth, height: 50)
        nameLabel.frame = CGRect(x: profileImageView.right + 5, y: 0, width: contentView.width - profileImageView.width - 10 - buttonWidth, height: contentView.height / 2)
        userNameLabel.frame = CGRect(x: profileImageView.right + 5, y: nameLabel.bottom, width: contentView.width - profileImageView.width - 10 - buttonWidth, height: contentView.height / 2)
    }
    
    @objc func didTapFollow() {
        guard let model = self.model else {
            return
        }
        delegate?.UsersProfileTableViewCellDidTapFollowbtn(model: model)
    }
    public func configure(model: UserRealtionship) {
        self.model = model
        nameLabel.text = model.name
        userNameLabel.text = model.userName
        switch model.type {
        case .following:
            //show UnFollow Button
            followBtn.setTitle("unfollow", for: .normal)
            followBtn.setTitleColor(.label, for: .normal)
            followBtn.layer.borderWidth = 1
            followBtn.backgroundColor = UIColor.systemBackground
            followBtn.layer.borderColor = UIColor.label.cgColor
            break
        case .not_following:
            // show Follow Button
            followBtn.setTitle("Follow", for: .normal)
            followBtn.setTitleColor(.white, for: .normal)
            followBtn.layer.borderWidth = 0
            followBtn.backgroundColor = UIColor.link
            break
        }
    }
    
}
