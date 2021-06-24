//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 17/05/21.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    
    func ProfileInfoHeaderCollectionReusableViewdidTapPostsButton( cell: ProfileInfoHeaderCollectionReusableView)
    func ProfileInfoHeaderCollectionReusableViewdidTapFollowersButton( cell: ProfileInfoHeaderCollectionReusableView)
    func ProfileInfoHeaderCollectionReusableViewdidTapFollowingButton( cell: ProfileInfoHeaderCollectionReusableView)
    func ProfileInfoHeaderCollectionReusableViewdidTapeditProfileButton( cell: ProfileInfoHeaderCollectionReusableView)
    
}


class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
       
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate? = nil
    
    let profileImageView: UIImageView = {
       let img = UIImageView()
        img.clipsToBounds = true
        img.backgroundColor = UIColor.red
        return img
    }()
    
    let postsButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Posts", for: .normal)
        btn.setTitleColor(UIColor.label, for: .normal)
        return btn
    }()
    let followersButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Followers", for: .normal)
        btn.setTitleColor(UIColor.label, for: .normal)
        return btn
    }()
    let followingButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("Following", for: .normal)
        btn.setTitleColor(UIColor.label, for: .normal)
        return btn
    }()
    
    let editYourProfileBtn: UIButton = {
       let btn = UIButton()
        btn.setTitle("Edit Your Profile", for: .normal)
        btn.setTitleColor(UIColor.label, for: .normal)
        return btn
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Nuthan Raju"
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    let bioLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "This is my first Account!"
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // backgroundColor = UIColor.green
        clipsToBounds = true
        addButtonActions()
        addSubview(profileImageView)
        addSubview(postsButton)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
        addSubview(editYourProfileBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let photoImageSize = frame.width / 4
        profileImageView.frame = CGRect(x: 5, y: 5, width: photoImageSize, height: photoImageSize).integral
        profileImageView.layer.cornerRadius = photoImageSize / 2
        profileImageView.layer.masksToBounds = true
        
        let countBtnWidth = (width - 10 - profileImageView.width) / 3
        let btnHeight = profileImageView.height / 2
        
        postsButton.frame = CGRect(x: profileImageView.right + 5, y: 5, width: countBtnWidth, height: btnHeight)
        followersButton.frame = CGRect(x: postsButton.right, y: 5, width: countBtnWidth, height: btnHeight)
        followingButton.frame = CGRect(x: followersButton.right, y: 5, width: countBtnWidth, height: btnHeight)
        
        nameLabel.frame = CGRect(x: 5, y: profileImageView.bottom + 5, width: width - 10, height: 30)
        let bioLabelsize = bioLabel.sizeThatFits(frame.size)
        bioLabel.frame = CGRect(x: 5, y: nameLabel.bottom + 5, width: width - 10, height: bioLabelsize.height)
        
        editYourProfileBtn.frame = CGRect(x: 5, y: 5 + bioLabel.bottom, width: width - 10, height: 50)
        
    }
    
    func addButtonActions() {
        postsButton.addTarget(self, action: #selector(didTapPostBtn), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        editYourProfileBtn.addTarget(self, action: #selector(didTapEditYourProfileBtn), for: .touchUpInside)
    }

    @objc func didTapPostBtn() {
        delegate?.ProfileInfoHeaderCollectionReusableViewdidTapPostsButton(cell: self)
    }
    @objc func didTapFollowersButton() {
        delegate?.ProfileInfoHeaderCollectionReusableViewdidTapFollowersButton(cell: self)
    }
    @objc func didTapFollowingButton() {
        delegate?.ProfileInfoHeaderCollectionReusableViewdidTapFollowingButton(cell: self)
        
    }
    @objc func didTapEditYourProfileBtn() {
        delegate?.ProfileInfoHeaderCollectionReusableViewdidTapeditProfileButton(cell: self)
    }
}
