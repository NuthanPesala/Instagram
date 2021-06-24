//
//  NotificationsFollowEventTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 19/05/21.
//

import UIKit

protocol NotificationsFollowEventTableViewCellDelegate: AnyObject {
    func NotificationsFollowEventdidTapFollowBtn(model: UserNotifications)
}

class NotificationsFollowEventTableViewCell: UITableViewCell {

    static let identifier = "NotificationsFollowEventTableViewCell"
    
    weak var delegate: NotificationsFollowEventTableViewCellDelegate? = nil
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.secondarySystemBackground
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "@joe liked your photo"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    private let followBtn: UIButton = {
       let btn = UIButton()
        return btn
    }()
    
    private var model: UserNotifications!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(label)
        addSubview(followBtn)
        selectionStyle = .none
        followBtn.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        profileImageView.layer.cornerRadius = profileImageView.width / 2
        
        let size: CGFloat = 100
        
        followBtn.frame = CGRect(x: contentView.width - 5 - size, y: (contentView.height - 40) / 2, width: size, height: 40)
        
        label.frame = CGRect(x: profileImageView.right + 5, y: 0, width: contentView.width - size - profileImageView.width - 16, height: contentView.height)
    }
    public func configure(model: UserNotifications) {
        self.model = model
        switch model.type {
        case .like(_):
            
            break
        case .follow(let state) :
            switch  state {
            case .following:
                followBtn.setTitle("Unfollow", for: .normal)
                followBtn.setTitleColor(UIColor.label, for: .normal)
                followBtn.backgroundColor = UIColor.systemBackground
                followBtn.layer.borderWidth = 1
                followBtn.layer.borderColor = UIColor.label.cgColor
            case .not_following:
                followBtn.setTitle("Follow", for: .normal)
                followBtn.setTitleColor(UIColor.label, for: .normal)
                followBtn.backgroundColor = UIColor.link
            }
        }
        label.text = "sri_devi Started Following You"
//        var imageData = Data()
//        do {
//            imageData = try! Data(contentsOf: model.user.profilePhoto)
//        }catch {
//            print("Error")
//        }
//        profileImageView.image = UIImage(data: imageData)
          profileImageView.image = UIImage(named: "1")
    }
    
    @objc func didTapFollow() {
        guard let model = self.model else {
            return
        }
        delegate?.NotificationsFollowEventdidTapFollowBtn(model: model)
    }
}
