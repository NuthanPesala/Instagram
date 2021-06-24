//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 16/05/21.
//

import UIKit

class ProfileViewController: UIViewController {

    private var collectionView: UICollectionView!
    
    let userPosts: [UserPost]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didTapSettingsBtn))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
       // layout.itemSize = CGSize(width: view.width / 3, height: view.width / 3)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // cell
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        //Headers
        collectionView.register(ProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        collectionView.register(ProfileTabsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        guard let cv = collectionView else {
            return
        }
        view.addSubview(cv)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func didTapSettingsBtn() {
      let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .fullScreen
        settingsVC.title = "Settings"
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
  

}

extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
           // return userPosts!.count
        return 30
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // guard let model = self.userPosts?[indexPath.row] else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        //cell.configure(model: model)
        cell.photoImage.image = UIImage(named: "1")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        if indexPath.section == 0 {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
            header.delegate = self
        return header
        }
        let tabHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier, for: indexPath) as! ProfileTabsCollectionReusableView
        tabHeader.delegate = self
        return tabHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
        return CGSize(width: collectionView.width, height: collectionView.height / 3)
        }
        return CGSize(width: collectionView.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
             let model = self.userPosts?[indexPath.item]
        
        let postVC = PostViewController(model: model!)
        postVC.title = "Post"
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.width - 10) / 3
        return CGSize(width: size - 2, height: size - 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}


extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func ProfileInfoHeaderCollectionReusableViewdidTapPostsButton(cell: ProfileInfoHeaderCollectionReusableView) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
    }
    
    func ProfileInfoHeaderCollectionReusableViewdidTapFollowersButton(cell: ProfileInfoHeaderCollectionReusableView) {
        print("Followers")
        var mockData = [UserRealtionship]()
        
        for x in 0..<10 {
            mockData.append(UserRealtionship(name: "Nuthan", userName: "@raju_pesala", type: x % 2 == 0 ? .following : .not_following))
        }
        
        let followVC = ListViewController(model: mockData)
        followVC.title = "Followers"
        let navVC = UINavigationController(rootViewController: followVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func ProfileInfoHeaderCollectionReusableViewdidTapFollowingButton(cell: ProfileInfoHeaderCollectionReusableView) {
        print("Following")
        var mockData = [UserRealtionship]()
        
        for x in 0..<10 {
            mockData.append(UserRealtionship(name: "Nuthan", userName: "@raju_pesala", type: x % 2 == 0 ? .following : .not_following))
        }
        
        let followVC = ListViewController(model: mockData)
        followVC.title = "Following"
        let navVC = UINavigationController(rootViewController: followVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func ProfileInfoHeaderCollectionReusableViewdidTapeditProfileButton(cell: ProfileInfoHeaderCollectionReusableView) {
        let editVC = EditProfileViewController()
        editVC.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: editVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    
}

extension ProfileViewController: ProfileTabsCollectionReusableDelegate {
    func ProfileTabsCollectionReusabledidTapGridBtn() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
    }
    
    func ProfileTabsCollectionReusabledidTapTagBtn() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
    }
    
    
}
