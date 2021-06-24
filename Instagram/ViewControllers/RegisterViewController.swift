//
//  RegisterViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 14/05/21.
//

import UIKit

@objcMembers
class RegisterViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var phNumberBtn: UIButton!
    @IBOutlet weak var emaiBtn: UIButton!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var stackViewTf: UIStackView!
    @IBOutlet weak var nxtBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var btnsStackView: UIStackView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var countryCodeWidth: NSLayoutConstraint!
    @IBOutlet weak var emailTfLeading: NSLayoutConstraint!
    @IBOutlet weak var phNumberBtmView: UIView!
    @IBOutlet weak var emailBtmView: UIView!
    
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: UITextField!
    @IBOutlet weak var tf6: UITextField!
    
    @IBOutlet weak var resendOtp: UIButton!
    @IBOutlet weak var otpTimerLabel: UILabel!
    @IBOutlet weak var nxtBtntopConst: NSLayoutConstraint!
    
    var image = UIImage()
    var timer = Timer()
    var seconds = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        countryCodeBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        phNumberBtn.addTarget(self, action: #selector(phNumberBtnTapped), for: .touchUpInside)
        emaiBtn.addTarget(self, action: #selector(emaiBtnTapped), for: .touchUpInside)
        nxtBtn.addTarget(self, action: #selector(didTapNxt), for: .touchUpInside)
        resendOtp.addTarget(self, action: #selector(didTapResend), for: .touchUpInside)
        logInBtn.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
       
        emaiBtn.tintColor = UIColor.lightGray
        
        profilePic.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePic.addGestureRecognizer(tapGesture)
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        profilePic.layer.masksToBounds = true
        
        emailTf.placeholder = "Phone Number"
        emailTfLeading.constant = 100
        countryCodeWidth.constant = 80
        countryCodeView.isHidden = false
        emailBtmView.isHidden = true
        

        nxtBtn.setTitle("Send OTP", for: .normal)
        resendOtp.isHidden = true
        otpTimerLabel.isHidden = true
        resendOtp.isUserInteractionEnabled = false
        
        self.tfDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
      func handleOtpTimer() {
        seconds -= 1
        resendOtp.isHidden = false
        otpTimerLabel.isHidden = false
        otpTimerLabel.text = "resends otp in 00:\(seconds)s"
        if seconds == 0 {
            resendOtp.isUserInteractionEnabled = true
            timer.invalidate()
            seconds = 60
        }
    }
    func didTapLogin() {
        navigationController?.popViewController(animated: true    )
    }
    
   func btnTapped() {
        let countryVC = CountrySearchViewController()
        countryVC.delegate = self
        countryVC.modalPresentationStyle = .overCurrentContext
        self.present(countryVC, animated: true, completion: nil) 
    }
   func phNumberBtnTapped() {
        phNumberBtn.tintColor = UIColor.link
        emaiBtn.tintColor = UIColor.lightGray
        phNumberBtmView.isHidden = false
        emailBtmView.isHidden =  true
        emailTf.placeholder = "Phone Number"
        emailTfLeading.constant = 100
        countryCodeWidth.constant = 80
        countryCodeView.isHidden = false
        nxtBtntopConst.constant = 100
        stackViewTf.isHidden = false
        nxtBtn.setTitle("Send OTP", for: .normal)
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    func emaiBtnTapped() {
        emaiBtn.tintColor = UIColor.link
        phNumberBtn.tintColor = UIColor.lightGray
        phNumberBtmView.isHidden = true
        emailBtmView.isHidden =  false
        emailTf.placeholder = "Email Address"
        emailTfLeading.constant = 20
        countryCodeWidth.constant = 0
        countryCodeView.isHidden = true
        nxtBtntopConst.constant = 30
        stackViewTf.isHidden = true
        nxtBtn.setTitle("next", for: .normal)
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
   func didTapImage() {
        let actionSheet = UIAlertController(title: "Choose Photo source", message: "Add Image For Your Profile", preferredStyle: .actionSheet)
        let picker = UIImagePickerController()
        picker.delegate = self
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            }else {
                //popup alert
                self.showAlert(title: "Camera is not found", message: "In simulator camera is not in use")
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
    
    func didTapNxt() {
        guard let text = emailTf.text, !text.isEmpty  else {
            return
        }
        
        if  nxtBtn.currentTitle == "Send OTP" {
            guard  text.isNumeric, text.count >= 10 else {
                showAlert(title: "Phone Number is not valid", message: "Please Enter Valid Number")
                return
            }
            AuthManager.shared.sendOtp(phoneNumber: "+91"+text) {[weak self] id in
                UserDefaults.standard.set(id, forKey: "VerificationId")
                self?.nxtBtn.setTitle("next", for: .normal)
            }
           
        }else {
            let otpText = "\(tf1.text ?? "")" + "\(tf2.text ?? "")" + "\(tf3.text ?? "")" + "\(tf4.text ?? "")" + "\(tf5.text ?? "")" + "\(tf6.text ?? "")"
             
             guard let otp = otpText as? String else {
                 return
             }
            if text.contains("@"), text.contains(".") {
                self.navigateToSingUpVc(otp: "", email: text, phNumber: "", image: image)
            }else  if text.isNumeric, text.count >= 10  {
                self.navigateToSingUpVc(otp: otp, email: "", phNumber: "+91"+text, image: image)
            }
        }
    }
    
    func navigateToSingUpVc(otp: String, email: String, phNumber: String, image: UIImage) {
        let signVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        signVC.modalPresentationStyle = .fullScreen
        signVC.email = email
        signVC.phNumber = phNumber
        signVC.img = image
        signVC.otp = otp
        self.navigationController?.pushViewController(signVC, animated: true)
    }
    
    func didTapResend() {
        print("resend OTP")
    }
    
    func insertUserInDatabase (data: [String: Any], uid: String) {
        DatabaseManager.shared.addingUserData(uid: uid, data: data) { (success) in
            if (success) {
                print("Document successfully written!")
            }else {
                print("Document successfully not written!")
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height
    }

}

extension RegisterViewController: searchDelegate {
    func getCountryName(name: String, code: String) {
        let countryName = String(name.prefix(2))
        self.countryCodeBtn.setTitle(countryName+code, for: .normal)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePic.image = selectImage
            self.image = selectImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func tfDelegates() {
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        tf5.delegate = self
        tf6.delegate = self
        
        tf1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tf2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tf3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tf4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tf5.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        tf6.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
     func textFieldDidChange(textField: UITextField){
            let text = textField.text
            if  text?.count == 1 {
                switch textField{
                case tf1:
                  tf2.becomeFirstResponder()
                case tf2:
                    tf3.becomeFirstResponder()
                case tf3:
                    tf4.becomeFirstResponder()
                case tf4:
                  tf5.becomeFirstResponder()
                case tf5:
                    tf6.becomeFirstResponder()
                case tf6:
                    tf6.resignFirstResponder()
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleOtpTimer), userInfo: nil, repeats: true)
                default:
                    break
                }
            }
            if  text?.count == 0 {
                switch textField{
                case tf1:
                    tf1.becomeFirstResponder()
                case tf2:
                    tf1.becomeFirstResponder()
                case tf3:
                    tf2.becomeFirstResponder()
                case tf4:
                    tf3.becomeFirstResponder()
                case tf5:
                    tf4.becomeFirstResponder()
                case tf6:
                    tf5.becomeFirstResponder()
                default:
                    break
                }
            }
            else{

            }
        }

}

extension UIViewController {
    
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
