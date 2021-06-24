//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 15/05/21.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    var users = [User]()
    
    func addingUserData(uid: String,data: [String: Any], completion: @escaping (Bool) -> Void) {
        db.collection("Users").document(uid).setData(data) { (error) in
            if let err = error {
                  print("Error writing document: \(err)")
                completion(false)
              } else {
                  print("Document successfully written!")
                completion(true)
              }
        }
    }
    
    func getUserDetails(userId: String,completion: @escaping ((MockData) -> Void)) {
        
        var user = MockData(userName: "", userId: "", bio: "", profilePhoto: "", email: "", phNumber: "")
        db.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            if let name = snapshot["user_name"] as? String {
                user.userName = name
            }
            if let imageUrl = snapshot["image_url"] as? String {
                user.profilePhoto = imageUrl
            }
            if let userId = snapshot["uid"] as? String {
                user.userId = userId
            }
            if let mobile = snapshot["phone_number"] as? String {
                user.phNumber = mobile
            }
            completion(user)
        }
    
    }
    
}
