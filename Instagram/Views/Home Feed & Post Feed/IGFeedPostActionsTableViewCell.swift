//
//  IGFeedPostActionsTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 19/05/21.
//

import UIKit

class IGFeedPostActionsTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostActionsTableViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let likeButton: UIButton = {
       let button = UIButton()
        let config = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let commentButton: UIButton = {
       let button = UIButton()
        let config = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "bubble.right", withConfiguration: config), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let sendButton: UIButton = {
       let button = UIButton()
        let config = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "paperplane",withConfiguration: config), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(stackView)
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(commentButton)
        stackView.addArrangedSubview(sendButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = CGRect(x: 5, y: 2, width: (contentView.width - 5) / 3, height: contentView.height - 4)
    }

}
