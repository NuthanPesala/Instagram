//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 24/05/21.
//

import UIKit
import FirebaseFirestore

@objcMembers
class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var phNumberTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var register: UIButton!
    
    var email = ""
    var phNumber = ""
    var otp = ""
    var img = UIImage()
    
    private var backButton: UIButton = {
       let btn = UIButton()
        btn.clipsToBounds = true
        btn.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        userNameTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        emailTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        phNumberTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        passwordTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        
        userNameTf.leftViewMode = .always
        emailTf.leftViewMode = .always
        phNumberTf.leftViewMode = .always
        passwordTf.leftViewMode = .always
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        register.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        if email != "" || phNumber != "" {
            emailTf.text = email
            phNumberTf.text = phNumber
            if email != "" {
                emailTf.isUserInteractionEnabled = false
                emailTf.backgroundColor = UIColor.systemGray5
                
            }else if phNumber != "" {
                phNumberTf.isUserInteractionEnabled = false
                phNumberTf.backgroundColor = UIColor.systemGray5
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: 10, y: 50, width: 30, height: 30)
    }
    
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapRegister() {
      
        guard let email = emailTf.text , let mobile = phNumberTf.text,let name = userNameTf.text, let password = passwordTf.text, password.count >= 8 else {
            return
        }
        if img == UIImage() {
            StorageManager.shared.imageFromInitials(name: name) { (image) in
                self.img = image
            }
        }
        if phNumber != "" {
            guard let id = UserDefaults.standard.string(forKey: "VerificationId") else {
                return
            }
            
            self.signInWithPhNumber(image: self.img, emailId: email, verificationId: id, verificationCode: otp,name: name, mobile: mobile)
        }else {
            self.signInWithEmail(emailId: email, name: name, password: password, image: self.img, mobile: mobile)
        }
    }

    func signInWithPhNumber(image: UIImage, emailId: String, verificationId: String, verificationCode: String,name: String, mobile: String) {
        
        AuthManager.shared.signInWithPhoneNumber(verificationId: verificationId, verificationCode: verificationCode) {[weak self] (id, succcess) in
            if succcess {
             //  StorageManager.shared.uploadUserProfilePic(image: image, emailId: emailId) { [weak self] imageUrl in
                let data: [String: Any] = [
                    "user_name": name,
                    "email": emailId,
                    "phone_number": mobile,
                    "uid": id,
                    "image_url": "",
                    "messages": [[String: Any]](),
                    "bio": String(),
                    "gender": "",
                    "join_date": FirebaseFirestore.Timestamp(date: Date())
                ]
                DatabaseManager.shared.addingUserData(uid: id, data: data) { (success) in
                    if success {
                        let tabvc = self?.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                        self?.navigationController?.pushViewController(tabvc, animated: true)
                    }
                }
             // }
            }
        }
    }
    
    func signInWithEmail(emailId: String, name: String, password: String, image: UIImage, mobile: String) {
        
        AuthManager.shared.createAccountInFirebase(email: emailId, userName: name, password: password) { [weak self] (success, id) in
            if success {
               // StorageManager.shared.uploadUserProfilePic(image: image, emailId: emailId) { [weak self] imageUrl in
                    let data: [String: Any] = [
                        "user_name": name,
                        "email": emailId,
                        "phone_number": mobile,
                        "uid": id,
                        "image_url": "",
                        "messages": [[String: Any]](),
                        "bio": String(),
                        "gender": "",
                        "join_date": FirebaseFirestore.Timestamp(date: Date())
                    ]
                    DatabaseManager.shared.addingUserData(uid: id, data: data) { (success) in
                        if success {
                            let tabvc = self?.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                            self?.navigationController?.pushViewController(tabvc, animated: true)
                        }
                    }
               // }
            }
        }
        
    }
}
