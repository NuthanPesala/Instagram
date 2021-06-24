//
//  ExtensionConversationsViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 28/05/21.
//

import UIKit
import MessageKit
import AVFoundation
import CoreLocation
import FirebaseFirestore

extension ConversationsViewController {
    
    ///Snding Message
    func insertNewMessage(message: String) {
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            return
        }
        guard otherId != "" else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let msgId = String(userId.prefix(4)) + String(otherId.prefix(4)) + "\(formatter.string(from: Date()))"
        
        var conversations = [[String : Any]]()
        var convData = DataModel(message: "", is_read: false, to_id: "", from_id: "", type: "", message_id: "", sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: 0,longitude: 0)
        
        self.db.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any] {
                    if let uid = data["uid"] as? String {
                        if userId == uid {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }
                                    
                                    conversations.append(convData.asDictionary)
                                }
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: message, is_read: false, to_id: self.otherId, from_id: userId, type: "text", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "", video_url: "",latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.text(message), isRead: false, type: "text", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                    
                                }
                                
                            }else {
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: message, is_read: false, to_id: self.otherId, from_id: userId, type: "text", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.text(message), isRead: false, type: "text", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        }else if uid == self.otherId {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }
                                    
                                    conversations.append(convData.asDictionary)
                                    
                                }
                                
                                let msgData = DataModel(message: message, is_read: false, to_id: self.otherId, from_id: userId, type: "text", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                print(uploadMessages,"3")
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                    
                                }
                                
                            }else {
                                let msgData = DataModel(message: message, is_read: false, to_id: self.otherId, from_id: userId, type: "text", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()), image_url: "",video_url: "",latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                print(uploadMessages,"4")
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    /// Sending Image Message
    func insertImageMessageInDatabase(imageUrl: String, image: UIImage) {
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            return
        }
        guard otherId != "" else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let msgId = String(userId.prefix(4)) + String(otherId.prefix(4)) + "\(formatter.string(from: Date()))"
        
        var conversations = [[String : Any]]()
        var convData = DataModel(message: "", is_read: false, to_id: "", from_id: "", type: "", message_id: "", sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: 0,longitude: 0)
        
        self.db.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any] {
                    if let uid = data["uid"] as? String {
                        if uid == userId {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }

                                    
                                    conversations.append(convData.asDictionary)
                                }
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "image", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: imageUrl, video_url: "",latitude: 0,longitude: 0)
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        let item = Media(url: URL(string: imageUrl), image: image, placeholderImage: image, size: CGSize(width: 300, height: 300))
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.photo(item), isRead: false, type: "image", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                    
                                }
                                
                            }else {
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "image", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: imageUrl,video_url: "",latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        let item = Media(url: URL(string: imageUrl), image: image, placeholderImage: image, size: CGSize(width: 300, height: 300))
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.photo(item), isRead: false, type: "image", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        }else if uid == self.otherId {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }

                                    
                                    conversations.append(convData.asDictionary)
                                }
                                
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "image", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: imageUrl,video_url: "",latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                    
                                }
                                
                            }else {
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "image", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()), image_url: imageUrl,video_url: "",latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    /// Sending Video Message
    func insertVideoMessageInDatabase(videoUrl: String) {
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            return
        }
        guard otherId != "" else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let msgId = String(userId.prefix(4)) + String(otherId.prefix(4)) + "\(formatter.string(from: Date()))"
        
        var conversations = [[String : Any]]()
        var convData = DataModel(message: "", is_read: false, to_id: "", from_id: "", type: "", message_id: "", sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: 0,longitude: 0)
        
        self.db.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any] {
                    if let uid = data["uid"] as? String {
                        if uid == userId {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }

                                    
                                    conversations.append(convData.asDictionary)
                                }
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "video", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "", video_url: videoUrl,latitude: 0,longitude: 0)
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        let item = Media(url: URL(string: videoUrl), image: UIImage(systemName: "play") ?? UIImage(), placeholderImage: UIImage(systemName: "play") ?? UIImage(), size: CGSize(width: 250, height: 250))
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.video(item), isRead: false, type: "video", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                    
                                }
                                
                            }else {
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "video", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: videoUrl,latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        let item = Media(url: URL(string: videoUrl), image: UIImage(systemName: "play") ?? UIImage(), placeholderImage: UIImage(systemName: "play") ?? UIImage(), size: CGSize(width: 250, height: 250))
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.video(item), isRead: false, type: "video", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        }else if uid == self.otherId {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }

                                    
                                    conversations.append(convData.asDictionary)
                                }
                                
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "video", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: videoUrl,latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                    
                                }
                                
                            }else {
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "video", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()), image_url: "",video_url: videoUrl,latitude: 0,longitude: 0)
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    ///Sending Location Message
    func insertLocationMessageInDatabase(coordinates: CLLocationCoordinate2D)
    {
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            return
        }
        guard otherId != "" else {
            return
        }
    
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let msgId = String(userId.prefix(4)) + String(otherId.prefix(4)) + "\(formatter.string(from: Date()))"
        
        var conversations = [[String : Any]]()
        var convData = DataModel(message: "", is_read: false, to_id: "", from_id: "", type: "", message_id: "", sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: 0,longitude: 0)
        
        self.db.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any] {
                    if let uid = data["uid"] as? String {
                        if uid == userId {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }
                                    
                                    conversations.append(convData.asDictionary)
                                }
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "location", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "", video_url: "",latitude: Double(coordinates.latitude),longitude: Double(coordinates.longitude))
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        let item = Location(location: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), size: CGSize(width: 250, height: 250))
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.location(item), isRead: false, type: "location", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                    
                                }
                                
                            }else {
                                let time = FirebaseFirestore.Timestamp(date: Date())
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "location", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: Double(coordinates.latitude),longitude: Double(coordinates.longitude))
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(userId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        self.db.collection("Messages").document().setData(msgData.asDictionary) { (error) in
                                            if let error = error {
                                                print("Error:", error.localizedDescription as Any)
                                            }else {
                                                print("successfully Document Written")
                                            }
                                        }
                                        let item = Location(location: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), size: CGSize(width: 250, height: 250))
                                        self.messages.append(Message(sentDate: time.dateValue(), sender: self.sender, messageId: msgId, kind: MessageKind.location(item), isRead: false, type: "location", toId: self.otherId, fromId: userId))
                                        DispatchQueue.main.async {
                                            self.messagesCollectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        }else if uid == self.otherId {
                            conversations = [[String: Any]]()
                            if let msgs = data["messages"] as? [[String: Any]] {
                                for conversation in msgs {
                                    if let message = conversation["message"] as? String {
                                        convData.message = message
                                    }
                                    if let type = conversation["type"] as? String {
                                        convData.type = type
                                    }
                                    if let sentDate = conversation["sent_date"] as? Timestamp {
                                        convData.sent_date = sentDate
                                    }
                                    if let isRead = conversation["is_read"] as? Bool {
                                        convData.is_read = isRead
                                    }
                                    if let toId = conversation["to_id"] as? String {
                                        convData.to_id = toId
                                    }
                                    if let fromId = conversation["from_id"] as? String {
                                        convData.from_id = fromId
                                    }
                                    if let msgId = conversation["message_id"] as? String {
                                        convData.message_id = msgId
                                    }
                                    if let image_url = conversation["image_url"] as? String {
                                        convData.image_url = image_url
                                    }
                                    if let video_url = conversation["video_url"] as? String {
                                        convData.video_url = video_url
                                    }
                                    if let latitude = conversation["latitude"] as? Double {
                                        convData.latitude = latitude
                                    }
                                    if let longitude = conversation["longitude"] as? Double {
                                        convData.longitude = longitude
                                    }
                                    
                                    conversations.append(convData.asDictionary)
                                }
                                
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "location", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: Double(coordinates.latitude),longitude: Double(coordinates.longitude))
                                
                                conversations.append(msgData.asDictionary)
                                
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                    
                                }
                                
                            }else {
                                let msgData = DataModel(message: "", is_read: false, to_id: self.otherId, from_id: userId, type: "location", message_id: msgId, sent_date: FirebaseFirestore.Timestamp(date: Date()), image_url: "",video_url: "", latitude: Double(coordinates.latitude),longitude: Double(coordinates.longitude))
                                
                                conversations.append(msgData.asDictionary)
                                let uploadMessages: [String: Any] = ["messages":
                                                                        conversations
                                ]
                                
                                
                                self.db.collection("Users").document(self.otherId).setData(uploadMessages, merge: true) { (error) in
                                    if let error = error {
                                        print("Error:", error.localizedDescription as Any)
                                    }else {
                                        print("successfully Document Written")
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}
