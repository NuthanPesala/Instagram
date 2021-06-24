//
//  UsersViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 20/05/21.
//

import UIKit
import FirebaseFirestore

struct MockData {
    var userName: String
    var userId: String
    var bio: String
    var profilePhoto: String
    var email: String
    var phNumber: String
    
}

class UsersViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UsersTableViewCell.self, forCellReuseIdentifier: UsersTableViewCell.identifier)
        return tv
    }()
    
    let db = Firestore.firestore()
    
    lazy var noUsersView = NotificationsView()
    
    private var users = [MockData]()
    var data = [DataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        self.fetchMockData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didTapCompose))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(didTapback))
    }
    
    private func fetchMockData() {
        
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            return
        }
        var messagedata = DataModel(message: "", is_read: false, to_id: "", from_id: "", type: "", message_id: "", sent_date: Timestamp(date: Date()), image_url: "", video_url: "", latitude: 0, longitude: 0)
        var msgsData = [DataModel]()
        var msgDict = [String: DataModel]()

        db.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error:", error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any] {
                    if let uid = data["uid"] as? String {
                        if uid != userId {
                            if let messages = data["messages"] as? [[String: Any]] {
                                for msg in messages {
                                    if let toId = msg["to_id"] as? String {
                                        messagedata.to_id = toId
                                    }
                                    if let fromId = msg["from_id"] as? String {
                                        messagedata.from_id = fromId
                                    }
                                    if let message = msg["message"] as? String {
                                        messagedata.message = message
                                    }
                                    if let type = msg["type"] as? String {
                                        messagedata.type = type
                                    }
                                    if let imageUrl = msg["image_url"] as? String {
                                        messagedata.image_url = imageUrl
                                    }
                                    if let videoUrl = msg["video_url"] as? String {
                                        messagedata.video_url = videoUrl
                                    }
                                    if let latitude = msg["latitude"] as? Double {
                                        messagedata.latitude = latitude
                                    }
                                    if let longitude = msg["longitude"] as? Double {
                                        messagedata.longitude = longitude
                                    }
                                    
                                    msgDict[messagedata.to_id] = messagedata
                                    
                                }
                                
                            }
                        }
                    }
                }
            }
            msgsData = Array(msgDict.values)
            msgsData = msgsData.sorted(by: {$0.sent_date.compare($1.sent_date) == .orderedDescending})
            self.data = msgsData
            DispatchQueue.main.async {
                if self.data.count == 0 {
                    self.view.addSubview(self.noUsersView)
                    self.noUsersView.frame = CGRect(x: 0, y: 0, width: self.view.width / 2, height: self.view.width / 4)
                    self.noUsersView.center = self.view.center
                    self.noUsersView.title = "No Users yet..!"
                    return
                }
                self.tableView.reloadData()
            }
        }
        
    }

    @objc func didTapback() {
        self.dismiss(animated: true, completion: nil)
    }
   
    @objc func didTapCompose() {
        let composeVC = ComposeViewController()
        navigationController?.pushViewController(composeVC, animated: true)
    }
  

}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.identifier, for: indexPath) as! UsersTableViewCell
        let msg = data[indexPath.row]
       
        DatabaseManager.shared.getUserDetails(userId: msg.to_id) { (user) in
            cell.configure(model: user, message: msg)
        }
        cell.selectionStyle = .none
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = ConversationsViewController()
        let user = self.data[indexPath.row]
        navigationController?.pushViewController(chatVC, animated: true)
        DatabaseManager.shared.getUserDetails(userId: user.to_id) { (user) in
            chatVC.title = user.userName
            chatVC.otherId = user.userId
        }
    }
}
