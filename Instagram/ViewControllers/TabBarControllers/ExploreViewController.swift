//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 20/05/21.
//

import UIKit

class ExploreViewController: UIViewController {

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search..."
        return searchBar
    }()
    
    private let dimmedView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        view.isHidden = true
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        cv.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        cv.backgroundColor = UIColor.systemBackground
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        view.addSubview(collectionView)
        view.addSubview(dimmedView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        dimmedView.frame = view.bounds
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photoImage.image = UIImage(named: "3")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.width
        return CGSize(width: size / 2, height: size / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text ?? "")
        self.dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel)), animated: true)
    }
    @objc func didTapCancel() {
        searchBar.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
        self.dimmedView.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
