//
//  SettingsViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 16/05/21.
//

import UIKit
import SafariServices

struct SettingsCellModel {
    let title: String
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    var data = [[SettingsCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = UIColor.systemBackground
        configureModels()
    }

    private func configureModels() {
        data.append([
            SettingsCellModel(title: "Edit Profile", handler: {
                self.didTapEditProfile()
            }),
            SettingsCellModel(title: "Invite Friends", handler: {
                print("Invite Friends")
            }),
            SettingsCellModel(title: "Save Original Posts", handler: {
                print("Save Original Posts")
            })
        ])
        data.append([
            SettingsCellModel(title: "Terms Of Services", handler: {
                self.openUrl(url: "https://www.instagram.com/about/legal/terms/before-january-19-2013/")
            }),
            SettingsCellModel(title: "Privacy Policy", handler: {
                self.openUrl(url: "https://help.instagram.com/519522125107875")
            }),
            SettingsCellModel(title: "Help / Feedback", handler: {
                self.openUrl(url: "https://help.instagram.com/")
            })
        ])
        data.append([
            SettingsCellModel(title: "Log Out", handler: {
                self.didTapLogOut()
            })
            
        ])
    }
    
    func didTapEditProfile() {
        let editVC = EditProfileViewController()
        editVC.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: editVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func didTapLogOut() {
        AuthManager.shared.userTappedOnLogout { (success) in
            if (success) {
                let alertController = UIAlertController(title: "Are you sure want to Log Out?", message: "", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.navigateToLoginVC()
                }
            }
        }
    }
    func navigateToLoginVC() {
        if let loginVC  = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    func openUrl(url: String) {
        guard let fileUrl = URL(string: url) else {
            return
        }
        let sfVC = SFSafariViewController(url: fileUrl)
        
        self.present(sfVC, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource ,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.data[indexPath.section][indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
      
}
