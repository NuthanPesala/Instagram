//
//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 19/05/21.
//

import UIKit

class IGFeedPostHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    private let profileImage: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.circle")
        return image
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Yerra Pavan Kumar"
        label.textColor = UIColor.label
        return label
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubview(profileImage)
        addSubview(userNameLabel)
        addSubview(moreButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.frame = CGRect(x: 3, y: 3, width: contentView.height - 6, height: contentView.height - 6)
        let size = contentView.height - 4
        moreButton.frame = CGRect(x:contentView.width - size - 4, y: 2, width: size, height: size)
        userNameLabel.frame = CGRect(x: profileImage.right + 2, y: 0, width: contentView.width - size - profileImage.width - 4 , height: contentView.height)
    }

}
