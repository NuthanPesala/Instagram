//
//  HomeViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 13/05/21.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()
    var feedRenderModels = [HomeFeedRenderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        self.createMockModels()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Home"
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "message.fill"), style: .plain, target: self, action: #selector(didTapConversations)), animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "UserId") == nil {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

            let navVC = UINavigationController(rootViewController: loginVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    func createMockModels() {
        let user = User(userName: "", userId: "",bio: "", gender: Gender.Male, birthDate: Date(), count: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date(), profilePhoto: "", email: "", phNumber: "")
      
        
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(PostComment(identifier: "\(x)", userName: "Nuthan", comment: "This is the best post I have seen", commentDate: Date(), likes: []))
        }
        
        for x in 0...5 {
            let post = UserPost(identifier: "", postType: .photo, image: "\(x)",  thumbnailImage: URL(string: "https://www.google.com/")!, postUrl: URL(string: "https://www.google.com/")!, caption: nil, likeCounts: [], comments: [], createdDate: Date(), taggedUser: [], owner: user)
            
            let viewModel = HomeFeedRenderModel(header: PostRenderViewModel(renderType: PostRenderType.header(provider: user)),
                                                post: PostRenderViewModel(renderType: PostRenderType.primaryContent(provider: post)),
                                                actions: PostRenderViewModel(renderType: .actions(provider: "")),
                                                comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
        }
        
    }
    
    @objc func didTapConversations() {
        let userVC = UsersViewController()
        let navVC = UINavigationController(rootViewController: userVC)
        userVC.title = "Chats"
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate
{

    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model: HomeFeedRenderModel
        let x = section
        if x == 0 {
            model = feedRenderModels[0]
        }else {
           let position = x % 4 == 0 ? x / 4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // Header
            return 1
        }else if subSection == 1 {
            // Post
            return 1
        }else if subSection == 2 {
            // Actions
          return 1
        }else if subSection == 3 {
            //Comments
            let commentModel = model.comments
            
            switch commentModel.renderType {
            case .comments(let comments): return comments.count > 2 ? 2: comments.count
            case .header(provider: _) ,.primaryContent(provider: _),.actions(provider: _) :
                return 0
            
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: HomeFeedRenderModel
        let x = indexPath.section
        if x == 0 {
            model = feedRenderModels[0]
        }else {
           let position = x % 4 == 0 ? x / 4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // Header
            let header = model.header
            switch header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                return cell
            case .comments(_) ,.primaryContent(provider: _),.actions(provider: _) :
                return UITableViewCell()
            }
           
            
        }else if subSection == 1 {
            // Post
            let post = model.post
            switch post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                cell.configure(post: post)
                return cell
            case .comments(_) ,.header(provider: _),.actions(provider: _) :
                return UITableViewCell()
            }
          
        }else if subSection == 2 {
            // Actions
            let model = model.actions
            switch model.renderType {
            case .actions(let action):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                return cell
            case .comments(_) ,.primaryContent(provider: _),.header(provider: _) :
                return UITableViewCell()
            }
            
        }else if subSection == 3 {
            //Comments
            let commentModel = model.comments
            
            switch commentModel.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                
                return cell
            case .header(provider: _) ,.primaryContent(provider: _),.actions(provider: _) :
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        
        if subSection == 0 {
            return 70
        }else if subSection == 1 {
            return tableView.width
        }else if subSection == 2 {
            return 60
        }else if subSection == 3 {
            return 50
        }
     return 0
   }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
}
