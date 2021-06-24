//
//  PostViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 18/05/21.
//

import UIKit

enum PostRenderType {
    case header(provider: User) // User name , profile pic
    case primaryContent(provider: UserPost) // Post
    case actions(provider: String)// Like, share, Comment
    case comments(comments: [PostComment])
}

struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {
    
    var model: UserPost?
    
    var renderModels = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()
    
    init(model: UserPost?) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureModels() {
        guard let model = self.model else {
            return
        }
        //Header
        
        renderModels.append(PostRenderViewModel(renderType: .header(provider: model.owner)))
        
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: model)))
        
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        
        var comments = [PostComment]()
        for x in 0..<4 {
            comments.append(PostComment(identifier: "\(x)", userName: "Nuthan", comment: "Great Post", commentDate: Date(), likes: []))
        }
        
        renderModels.append(PostRenderViewModel(renderType: .comments(comments: comments)))
    }

}

extension PostViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  renderModels[section].renderType {
        case .header(_):
            return 1
        case .primaryContent(_):
            return 1
        case .actions(_):
            return 1
        case .comments(let comments):
        return comments.count > 4 ? 4 : comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        
        switch model.renderType {
        case .actions(let action):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
            return cell
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
            return cell
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        
        switch model.renderType {
        case .actions(_):
         return 60
        case .comments(_):
        return 50
        case .header(_):
        return 70
        case .primaryContent(_):
            return tableView.width
            
        }
    }
}
