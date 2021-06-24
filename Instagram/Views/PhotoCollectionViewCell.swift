//
//  PhotoCollectionViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 17/05/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
      let photoImage: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
  
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImage.frame = contentView.bounds
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImage)
        contentView.clipsToBounds = true
        accessibilityLabel = "Users Post Image"
        accessibilityHint = "Double-Tap to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: UserPost) {
        let url = model.thumbnailImage
        do {
           let imageData = try Data(contentsOf: url)
            photoImage.image = UIImage(data: imageData)
        }catch {
            print("Failed to get Image")
        }
       
    }
}
