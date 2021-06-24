//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 16/05/21.
//

import UIKit

struct EditProfileFormModel {
    let label: String
    let placeHolder: String
    var value: String?
}

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        return tv
    }()
    
    var models = [[EditProfileFormModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        self.view.addSubview(tableView)
        tableView.tableHeaderView = createHeaderView()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        configureModels()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = view.bounds
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 4).integral)
        let size = headerView.frame.size.height / 1.5
        
        let profilePhotoBtn = UIButton(frame: CGRect(x: (view.frame.size.width - size) / 2, y: (headerView.frame.size.height - size) / 2, width: size, height: size))
        headerView.addSubview(profilePhotoBtn)
        profilePhotoBtn.layer.masksToBounds = true
        profilePhotoBtn.layer.cornerRadius = size / 2
        profilePhotoBtn.addTarget(self, action: #selector(didTapPhoto), for: .touchUpInside)
        profilePhotoBtn.setBackgroundImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        profilePhotoBtn.tintColor = UIColor.label
        profilePhotoBtn.layer.borderWidth = 1
        profilePhotoBtn.layer.borderColor = UIColor.systemBackground.cgColor
        return headerView
    }
    
    @objc func didTapPhoto() {
        let actionSheet = UIAlertController(title: "Choose Photo source", message: "Add Image For Your Profile", preferredStyle: .actionSheet)
        let picker = UIImagePickerController()
        picker.delegate = self
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            }else {
                //popup alert
            }
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        camera.setValue(UIImage(systemName: "camera"), forKey: "Image")
        gallery.setValue(UIImage(systemName: "photo"), forKey: "Image")
        actionSheet.addAction(camera)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func didTapCancel() {
        self.dismiss(animated: true)
    }
    @objc func didTapSave() {
        self.dismiss(animated: true)
    }
 
    private func configureModels() {
        let section1Labels  = ["Name","UserName","Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeHolder: "Enter \(label)...", value: nil)
            section1.append(model)
        }
        models.append(section1)
        
        let section2Labels  = ["Email","Phone","Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels {
            let model = EditProfileFormModel(label: label, placeHolder: "Enter \(label)...", value: nil)
            section2.append(model)
        }
        models.append(section2)
        
    }

}


extension EditProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifier, for: indexPath) as! EditProfileTableViewCell
        cell.configureModels(model: model)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return ""
        }
        return "Personal Information"
    }
    
}

extension EditProfileViewController : EditProfileFormDelegate {
    func formTableViewCell(_ cell: EditProfileTableViewCell, didUpdateModel model: EditProfileFormModel) {
        print(model.value ?? "")
    }

}
