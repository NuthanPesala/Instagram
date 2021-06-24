//
//  NotificationsLikeEventTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 19/05/21.
//

import UIKit


protocol NotificationsLikeEventTableViewCellDelegate: AnyObject {
    func NotificationsFollowEventdidTapPostBtn(model: UserNotifications)
}

class NotificationsLikeEventTableViewCell: UITableViewCell {

    static let identifier = "NotificationsLikeEventTableViewCell"
    
    weak var delegate: NotificationsLikeEventTableViewCellDelegate? = nil
    
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
        label.backgroundColor = UIColor.red
        return label
    }()
    private let postBtn: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor.green
        return btn
    }()
    
    private var model: UserNotifications!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(label)
        addSubview(postBtn)
        selectionStyle = .none
        postBtn.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        profileImageView.layer.cornerRadius = profileImageView.width / 2
        
        let size = contentView.height - 4
        
        postBtn.frame = CGRect(x: contentView.width - 5 - size, y: 2, width: size, height: size)
        
        label.frame = CGRect(x: profileImageView.right + 5, y: 0, width: contentView.width - size - profileImageView.width - 16, height: contentView.height)
    }
    public func configure(model: UserNotifications) {
        self.model = model
        switch model.type {
        case .like(let post):
            postBtn.setImage(UIImage(named: "2"), for: .normal)
            break
        case .follow(_):
           
            break
        }
        label.text = model.text
//        var imageData = Data()
//        do {
//            imageData = try! Data(contentsOf: model.user.profilePhoto)
//        }catch {
//            print("Error")
//        }
//        profileImageView.image = UIImage(data: imageData)
        
        profileImageView.image = UIImage(named: "1")
    }
    
    @objc func didTapPost() {
        guard let model = self.model else {
            return
        }
        delegate?.NotificationsFollowEventdidTapPostBtn(model: model)
    }
}
