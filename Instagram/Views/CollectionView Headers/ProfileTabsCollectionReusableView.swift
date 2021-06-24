//
//  ProfileTabsCollectionReusableView.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 17/05/21.
//

import UIKit

protocol ProfileTabsCollectionReusableDelegate: AnyObject {
    func ProfileTabsCollectionReusabledidTapGridBtn()
    func ProfileTabsCollectionReusabledidTapTagBtn()
}
class ProfileTabsCollectionReusableView: UICollectionReusableView {
     static let identifier = "ProfileTabsCollectionReusableView"
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    let gridBtn: UIButton = {
       let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName:  "square.grid.2x2", withConfiguration: config)
        btn.setImage(image, for: .normal)
        btn.clipsToBounds = true
        btn.contentMode = .scaleToFill
        return btn
    }()
    
    let tagBtn: UIButton = {
       let btn = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "person.crop.rectangle", withConfiguration: config)
        btn.setImage(image, for: .normal)
        btn.clipsToBounds = true
        btn.contentMode = .scaleToFill
        return btn
    }()
    weak var delegate: ProfileTabsCollectionReusableDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .orange
        addSubview(stackView)
        stackView.addArrangedSubview(gridBtn)
        stackView.addArrangedSubview(tagBtn)
        gridBtn.addTarget(self, action: #selector(didTapGridBtn), for: .touchUpInside)
        tagBtn.addTarget(self, action: #selector(didTapTagBtn), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = CGRect(x: 5, y: 5, width: width - 10, height: height - 10)
    }
    @objc func didTapGridBtn() {
        delegate?.ProfileTabsCollectionReusabledidTapGridBtn()
    }
    @objc func didTapTagBtn() {
        delegate?.ProfileTabsCollectionReusabledidTapTagBtn()
    }
}
