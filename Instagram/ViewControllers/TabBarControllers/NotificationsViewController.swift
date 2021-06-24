//
//  NotificationsViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 19/05/21.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: UserFollowState)
}
struct UserNotifications {
    let user: User
    let text: String
    let type: UserNotificationType
}

class NotificationsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(NotificationsLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationsLikeEventTableViewCell.identifier)
        tv.register(NotificationsFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationsFollowEventTableViewCell.identifier)
        tv.backgroundColor = .systemBackground
        return tv
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    lazy var noNotificationsView = NotificationsView()
    
    var models = [UserNotifications]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notifications"
       // addNoNotificationsView()
        view.addSubview(spinner)
        view.addSubview(tableView)
        tableView.isHidden = true
        spinner.startAnimating()
        fetchNotifications()
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
        tableView.frame = view.bounds
    }
    
    private func addNoNotificationsView() {
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x:  0, y: 0, width: view.width / 2, height:  view.width / 4)
        noNotificationsView.center = view.center
        noNotificationsView.backgroundColor = UIColor.systemBackground
    }
    
    func fetchNotifications() {
        let user = User(userName: "", userId: "",bio: "", gender: Gender.Male, birthDate: Date(), count: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date(), profilePhoto: "", email: "", phNumber: "")
      
        let post = UserPost(identifier: "", postType: .photo, image: "",  thumbnailImage: URL(string: "https://www.google.com/")!, postUrl: URL(string: "https://www.google.com/")!, caption: nil, likeCounts: [], comments: [], createdDate: Date(), taggedUser: [], owner: user)
        for x in 0...100 {
            let model = UserNotifications(user: user, text: "@sri_devi Liked your Profile Picture", type: x % 2 == 0 ? UserNotificationType.like(post: post) : .follow(state: .following))
                
            models.append(model)
        }
        tableView.isHidden = false
        DispatchQueue.main.async {
            self.tableView .reloadData()
            self.spinner.stopAnimating()
        }
    }
    
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.row]
       
        switch model.type {
        case .like(_):
          let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsLikeEventTableViewCell.identifier, for: indexPath) as! NotificationsLikeEventTableViewCell
            cell.configure(model: model)
            cell.delegate = self
            return cell
        case .follow(_):
          let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsFollowEventTableViewCell.identifier, for: indexPath) as! NotificationsFollowEventTableViewCell
            cell.configure(model: model)
            cell.delegate = self
            return cell
        }
       
        
    }
    
    
}

extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped Posts")
        let model = self.models[indexPath.row]
        switch model.type {
        case .like(let post):
            let postVC = PostViewController(model: post)
            postVC.title = post.postType.rawValue
            let navVC = UINavigationController(rootViewController: postVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
        case .follow(_):
            break
        }
    }
}

extension NotificationsViewController: NotificationsLikeEventTableViewCellDelegate {
    func NotificationsFollowEventdidTapPostBtn(model: UserNotifications) {
        print("Tapped Posts")
        switch model.type {
        case .like(let post):
            let postVC = PostViewController(model: post)
            postVC.title = post.postType.rawValue
            let navVC = UINavigationController(rootViewController: postVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
        case .follow(_):
            break
        }
    }
}

extension NotificationsViewController: NotificationsFollowEventTableViewCellDelegate {
    func NotificationsFollowEventdidTapFollowBtn(model: UserNotifications) {
        print("\(model.user.userName) started Following you")
    }
}
