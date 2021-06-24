//
//  ComposeViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 24/05/21.
//

import UIKit
import FirebaseFirestore

class ComposeViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        return tv
    }()

    private var backButton: UIButton = {
       let btn = UIButton()
        btn.clipsToBounds = true
        btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        return btn
    }()
    
  
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    var users = [User]()
    let db = Firestore.firestore()
    private var  searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        self.fetchUsers()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(didTapBack))
        searchController.searchBar.placeholder =  "Search User..."
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
   @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    func fetchUsers() {
        db.collection("Users").getDocuments { (snapshot, error) in
            if let error = error  {
                print("Error:",error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            var user = User(userName: "", userId: "", bio: "", gender: Gender(rawValue: Gender.Male.rawValue)!, birthDate: Date(), count: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date(), profilePhoto: "", email: "", phNumber: "")
            var users = [User]()
            
            guard let userid = UserDefaults.standard.string(forKey: "UserId") else {
                return
            }
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any] {
                    if let id = data["uid"] as? String {
                        if id != userid {
                            user.userId = id
                            if let name = data["user_name"] as? String {
                                user.userName = name
                            }
                            if let email = data["email"] as? String {
                                user.email = email
                            }
                            if let phNumber = data["phone_number"] as? String {
                                user.phNumber = phNumber
                            }
                            if let imageUrl = data["image_url"] as? String {
                                user.profilePhoto = imageUrl
                            }
                            if let bio = data["bio"] as? String {
                                user.bio = bio
                            }
                            if let joinDate = data["join_date"] as? Timestamp {
                                user.joinDate = joinDate.dateValue()
                            }
                            users.append(user)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                print(users)
              
                self.users = users
                
                self.tableView.reloadData()
            }
        }
    }

}

extension ComposeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as! UsersTableViewCell
     
        let user = self.users[indexPath.row]
        cell.usersConfigure(withModel: user)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ConversationsViewController()
        let user = self.users[indexPath.row]
        chatVC.title = user.userName
        chatVC.otherId = user.userId
        
        navigationController?.pushViewController(chatVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

extension ComposeViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            self.fetchUsers()
            return
        }
        print(text)
        if self.users.count != 0 {
            self.users = users.filter({
                $0.userName.lowercased().contains(text.lowercased())
            })
            print(self.users)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}
