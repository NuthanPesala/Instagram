//
//  NotificationsView.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 19/05/21.
//

import UIKit

class NotificationsView: UIView {

    private let imageView: UIImageView = {
       let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "bell")
        iv.tintColor = UIColor.label
        return iv
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.label
        return label
    }()
    var title = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(label)
        label.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: (width - 50) / 2, y: 0, width: 50, height: 50)
        label.frame = CGRect(x: 5, y: imageView.bottom + 5, width: width - 10, height: height - 50)
    }
    
}
