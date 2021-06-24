//
//  AuthManager.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 15/05/21.
//

import UIKit
import FirebaseAuth

class AuthManager: NSObject {
    
    static let shared = AuthManager()
    
    func siginWithEmail(email: String?, userName: String?, password: String, completion: @escaping (Bool, String) -> Void) {
        guard let email = email else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let result = authResult else {
                return completion(false, "")
            }
            UserDefaults.standard.set(result.user.uid, forKey: "UserId")
            return completion(true, result.user.uid)
        }
    }
    
    func createAccountInFirebase(email: String?, userName: String?, password: String, completion: @escaping (Bool,String) -> Void) {
        guard let email = email else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // ...
            guard let result = authResult else {
                return
            }
            
            completion(true, result.user.uid)
            
        }
    }
    
    func userTappedOnLogout(completion: @escaping (Bool) -> Void) {
        do {
            try  Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "UserId")
            completion(true)
        }catch {
          print("Failed to Log Out")
            completion(false)
        }
    }
    
    func sendOtp(phoneNumber: String, completion: @escaping (String) -> Void) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            return completion(error.localizedDescription)
          }
            guard let id = verificationID else {
                return completion("")
            }
            completion(id)
        }
    }
    
    func signInWithPhoneNumber(verificationId: String, verificationCode: String, completion: @escaping (String,Bool) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
           
            guard let result = authResult else {
                return
            }
            UserDefaults.standard.set(result.user.uid, forKey: "UserId")
            completion(result.user.uid, true)
        }
    }
}
