//
//  UsersTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 20/05/21.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    static let identifier = "UsersTableViewCell"
    
    private let userDp: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.tintColor = UIColor.secondarySystemBackground
        return iv
    }()
    
    private let userName: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let msgLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userDp)
        addSubview(userName)
        addSubview(msgLabel)
        addSubview(timeLabel)
    }
  //  private var model: User?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        userDp.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        userDp.layer.cornerRadius = userDp.frame.width / 2
        timeLabel.frame = CGRect(x: contentView.width - 85, y: 3, width: 80, height: 25)
        userName.frame = CGRect(x: userDp.right + 4, y: 3, width: contentView.width - userDp.width - 92, height: (contentView.height - 3) / 2)
        msgLabel.frame = CGRect(x: userDp.right + 4, y: userName.bottom + 2, width: contentView.width - userDp.width - 4, height: (contentView.height - userName.height - 8  ))
    }
    func configure(model: MockData, message: DataModel) {
        userName.text = model.userName
        if model.profilePhoto == "" {
            StorageManager.shared.imageFromInitials(name: model.userName) { (image) in
                self.userDp.image = image
            }
        }
        switch message.type {
        case "text":
            msgLabel.text = message.message
        case "image":
            msgLabel.text = "Sent an image"
        case "video":
            msgLabel.text = "Sent an Video"
        case "location":
            msgLabel.text = "Location Sent"
        default:
            break            
            
        }
    }
    
    func usersConfigure(withModel: User) {
        userName.text = withModel.userName
        if withModel.bio == "" {
            msgLabel.text = "Hey There Im Using Instagram..."
        }else {
        msgLabel.text = withModel.bio
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        timeLabel.text = formatter.string(from: withModel.joinDate)
        if withModel.profilePhoto != "" {
        do {
            let imageData = try Data(contentsOf: URL(string: withModel.profilePhoto)!)
            userDp.image = UIImage(data: imageData)
        }catch {
            print("Error:,Failed to Download Pic")
        }
        }else {
            StorageManager.shared.imageFromInitials(name: withModel.userName) {[weak self] (image) in
                self?.userDp.image = image
            }
        }
    }
 
}
