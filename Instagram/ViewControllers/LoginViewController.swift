//
//  LoginViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 14/05/21.
//

import UIKit

class LoginViewController: UITableViewController {

    
    @IBOutlet weak var languageSelectionBtn: UIButton!
    @IBOutlet weak var emailAddressTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var forgetlogInBtn: UIButton!
    @IBOutlet weak var fblogInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
         logInBtn.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        languageSelectionBtn.addTarget(self, action: #selector(didTapLanguage), for: .touchUpInside)
        signUpBtn.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height
    }
    
    //IBActions
    @objc func didTapLogin() {
        guard let email = emailAddressTf.text, !email.isEmpty, let password = passwordTf.text, password.count >= 8, !password.isEmpty else {
            return
        }
       var emailId = ""
       var userName = ""
        
        if email.contains("@"),email.contains(".") {
            emailId = email
        }else {
            userName = email
        }
        AuthManager.shared.siginWithEmail(email: emailId, userName: userName, password: password) { success,id  in
            if success {
                //Home Screen
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                self.navigationController?.pushViewController(tabVC, animated: true)
            }else {
                print("Log In Failed")
            }
        }
    }
    
    @objc func didTapLanguage() {
        let countryVC = CountrySearchViewController()
        countryVC.modalPresentationStyle = .overCurrentContext
        countryVC.isFromLogin = true
        countryVC.langdelegate = self
        self.present(countryVC, animated: true, completion: nil)
    }
    
    @objc func didTapSignUp() {
        let signVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        signVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signVC, animated: true)
    }
}

extension LoginViewController: GetLangNameDelegate {
    func getLangName(langName: String, countryName: String) {
        DispatchQueue.main.async {
        self.languageSelectionBtn.setTitle(langName+""+"(\(countryName))", for: .normal)
        self.languageSelectionBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        self.languageSelectionBtn.semanticContentAttribute = .forceRightToLeft
        }
    }
}
