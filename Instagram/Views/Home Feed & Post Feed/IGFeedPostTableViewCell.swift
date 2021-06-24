//
//  IGFeedPostTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 19/05/21.
//

import UIKit
import AVFoundation

class IGFeedPostTableViewCell: UITableViewCell {
    
    static let identifier = "IGFeedPostTableViewCell"
    
     let postContent: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var playerLayer = AVPlayerLayer()
    private var player = AVPlayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.systemBackground
        addSubview(postContent)
        playerLayer.player = player
        playerLayer.frame = postContent.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        postContent.layer.addSublayer(playerLayer)

       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        postContent.frame = contentView.bounds
    }
  
    func configure(post: UserPost) {
        switch post.image {
        case "1":    postContent.image = UIImage(named: post.image)
        case "2":    postContent.image = UIImage(named: post.image)
        case "3":    postContent.image = UIImage(named: post.image)
        case "4":    postContent.image = UIImage(named: post.image)
        case "5":    postContent.image = UIImage(named: post.image)
        default:
            guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else {
                return
            }
            player = AVPlayer(url: url)
           postContent.image = UIImage(named: "bunny")
            //player.play()
        }
        
    }
    
}
