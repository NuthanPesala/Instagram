//
//  StorageManager.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 15/05/21.
//

import UIKit
import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    
    let storageRef = Storage.storage().reference()
    
    func dateFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-dd-mm-ssZ"
        return formatter.string(from: Date())
    }
    
    func imageFromInitials(name: String, withBlock: @escaping (_ image: UIImage)-> Void) {
        
        var string: String!
        let size = 40
        
        if name != ""  {
            string = String(name.first!).uppercased()
            
        }
        
        let label = UILabel()
        label.frame.size = CGSize(width: 100, height: 100)
        label.text = string
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont(name: label.font.familyName, size: CGFloat(size))
        label.backgroundColor = .secondarySystemBackground
        label.layer.cornerRadius = 25
        
        UIGraphicsBeginImageContext(label.frame.size)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        withBlock(image!)
    }
    
    func uploadUserProfilePic(image: UIImage,emailId: String, completion: @escaping (URL) -> Void) {
        
        guard let uploadData = image.pngData() else {
            return
        }
        var email = emailId.replacingOccurrences(of: "@", with: "_")
        email = String(email.dropLast(4))
        let fileName = email+dateFormatter()+"profilePic.jpeg"
        
        storageRef.child("Users_Profile_Pic").child(fileName).putData(uploadData, metadata: nil) { [weak self] (metadata, error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
            
            guard let downloadRef = self?.storageRef.child("Users_Profile_Pic").child(fileName) else {
                return
            }
            downloadRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error:", error.localizedDescription as Any)
                }
                guard let downloadUrl = url else {
                    return
                }
                completion(downloadUrl.absoluteURL)
            }

        }
    }
    
   
    func uploadImageInFirebaseStorage(image: UIImage, completion: @escaping (String, UIImage) -> Void) {
        guard let imgData = image.pngData() else {
            print("Image not found")
            return
        }
        let text = dateFormatter()
        
        storageRef.child("Message_image").child("Image\(text).jpeg").putData(imgData, metadata: nil) { [weak self] (metadata, error) in
            if let error = error {
                print(error.localizedDescription as Any)
            }
            guard let downloadRef = self?.storageRef.child("Message_image").child("Image\(text).jpeg") else {
                return
            }
            downloadRef.downloadURL { (downloadUrl, error) in
                if let error = error {
                    print(error.localizedDescription as Any)
                }
                guard let url = downloadUrl else {
                    return
                }
                completion(url.absoluteString, image)
            }
        }
    }
    
    
    func uploadVideoInFirebaseStorage(url: URL, completion: @escaping (String) -> Void) {
        let text = dateFormatter()
        do {
            let videoData = try Data(contentsOf: url)
            storageRef.child("Message_Videos").child("Video\(text).mov").putData(videoData, metadata: nil) { [weak self] (metadata, error) in
                if let error = error {
                    print(error.localizedDescription as Any)
                }
                guard let downloadRef = self?.storageRef.child("Message_Videos").child("Video\(text).mov") else {
                    return
                }
                downloadRef.downloadURL { (downloadUrl, error) in
                    if let error = error {
                        print(error.localizedDescription as Any)
                    }
                    guard let url = downloadUrl else {
                        return
                    }
                    completion(url.absoluteString)
                }
            }
        }catch {
            print("Failed to get video")
        }
    }
}



