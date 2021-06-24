//
//  Models.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 18/05/21.
//

import Foundation
import FirebaseFirestore


public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

enum Gender: String {
    case Male = "Male"
    case Female = "Female"
}

struct User {
    var userName: String
    var userId: String
    var bio: String
    var gender : Gender
    var birthDate: Date
    var count: UserCount
    var joinDate: Date
    var profilePhoto: String
    var email: String
    var phNumber: String
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

struct UserPost {
    let identifier: String
    let postType: UserPostType
    let image: String
    let thumbnailImage: URL
    let postUrl: URL //either Video Url or Full Resolution photo
    let caption: String?
    let likeCounts: [PostLikes]
    let comments: [PostComment]
    let createdDate: Date
    let taggedUser: [String]
    let owner: User
}

struct PostLikes {
    let userName: String
    let postIdentifier: String
}

struct CommentLikes {
    let userName: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let userName: String
    let comment: String
    let commentDate: Date
    let likes: [CommentLikes]
}

struct DataModel {
    var message: String
    var is_read: Bool
    var to_id: String
    var from_id: String
    var type: String
    var message_id: String
    var sent_date: Timestamp
    var image_url: String
    var video_url: String
    var latitude: Double
    var longitude: Double
    
    var asDictionary : [String:Any] {
      let mirror = Mirror(reflecting: self)
      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
        guard let label = label else { return nil }
        return (label, value)
      }).compactMap { $0 })
      return dict
    }
 
}
