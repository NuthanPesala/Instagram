//
//  ConversationsViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 20/05/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import AVFoundation
import FirebaseFirestore
import CoreLocation
import AVKit
import MobileCoreServices
import IQAudioRecorderController

struct Message: MessageType {
    var sentDate: Date
    var sender: SenderType
    var messageId: String
    var kind: MessageKind
    var isRead: Bool
    var type: String
    var toId: String
    var fromId: String
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var photoURL: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct Audio: AudioItem {
    var url: URL
    var duration: Float
    var size: CGSize
}

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}

class ConversationsViewController: MessagesViewController {

      var messages = [Message]()
      var sender: SenderType!
      var player = AVPlayer()
      var otherId = ""
      let db = Firestore.firestore()
      var user = User(userName: "", userId: "", bio: "", gender: Gender(rawValue: Gender.Male.rawValue)!, birthDate: Date(), count: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date(), profilePhoto: "", email: "", phNumber: "")
    
    lazy var imageView: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor.clear
        img.isHidden = true
        return img
    }()
    
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCurrentUser()
        messageInputBar.delegate = self
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: false)
        
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        showMessageTimestampOnSwipeLeft = true // default false
        
        messageInputBar.inputTextView.placeholder = "write a message..."
        
        
        self.setUpInputButton()
    }
    
    func getCurrentUser()  {
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            print("User Id is not found")
            return
        }
        db.collection("Users").whereField("uid", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error  {
                print("Error:",error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            for document in snapshot.documents {
                if let data = document.data() as? [String: Any] {
                    if let id = data["uid"] as? String {
                        if id == userId {
                            self.user.userId = id
                            if let name = data["user_name"] as? String {
                                self.user.userName = name
                            }
                            if let imageUrl = data["image_url"] as? String {
                                self.user.profilePhoto = imageUrl
                            }
                        }
                    }
                }
            }
            if self.user.userName != "" {
                self.sender = Sender(senderId: self.user.userId, displayName: self.user.userName, photoURL: self.user.profilePhoto)
                print(self.sender!)
                self.getAllConversations()
            }
            
        }
        
    }
    
    
    private func setUpInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 30, height: 30), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            
            self?.presentInputActionSheet()
        }
        
        let sendBtn = InputBarSendButton(frame: CGRect(x: 0,y: 0, width: 30, height: 30))
        let config = UIImage.SymbolConfiguration(scale: .large)
        sendBtn.setImage(UIImage(systemName: "mic.circle",withConfiguration: config), for: .normal)
        messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.setStackViewItems([sendBtn], forStack: .right, animated: false)
        sendBtn.onTouchUpInside { (btn) in
            self.setupAudioRecorder()
        }
        
        
        messageInputBar.setLeftStackViewWidthConstant(to: 30, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }

    
 
    
    // MARK: - Helpers

    func sendBtnTapped() {
        self.processInputBar(messageInputBar)
    }
    
    func setupAudioRecorder() {
        let audioVC = AudioViewController(delegate_: self)
        audioVC.presentAudioRecorder(target: self)
    }
    
    func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media", message: "What would you like to Attach?", preferredStyle: .actionSheet)
        
        let photo = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.presentPhotoActionSheet()
        }
        let audio = UIAlertAction(title: "Audio", style: .default) { (action) in
            print("audio")
            let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeAudio as String, kUTTypeMP3 as String], in: .import)
            picker.delegate = self
            picker.modalPresentationStyle = .formSheet
            self.present(picker, animated: true, completion: nil)
          
        }
        let video = UIAlertAction(title: "Video", style: .default) { (action) in
            self.presentVideoActionSheet()
        }
        let documents = UIAlertAction(title: "Documents", style: .default) { (action) in
            print("Documents")
        }
        let location = UIAlertAction(title: "Location", style: .default) { (action) in
           let pickerVC = LocationPickerViewController(coordinates: nil)
            pickerVC.title = "Pick a Location"
            pickerVC.completion = { [weak self] selectedCoordinates in
                let latitude = selectedCoordinates.latitude
                let longitude = selectedCoordinates.longitude
                print("lat:\(latitude),long:\(longitude)")
                self?.insertLocationMessageInDatabase(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
            self.navigationController?.pushViewController(pickerVC, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        photo.setValue(UIImage(systemName: "photo"), forKey: "image")
        audio.setValue(UIImage(systemName: "music.note"), forKey: "image")
        video.setValue(UIImage(systemName: "video"), forKey: "image")
        documents.setValue(UIImage(systemName: "doc"), forKey: "image")
        location.setValue(UIImage(systemName: "location"), forKey: "image")
        
        actionSheet.addAction(photo)
        actionSheet.addAction(audio)
        actionSheet.addAction(video)
        actionSheet.addAction(documents)
        actionSheet.addAction(location)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true)
    }
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Choose Photo Source", message: "", preferredStyle: .actionSheet)
        let picker = UIImagePickerController()
        picker.delegate = self
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }else {
                self.showAlert(title: "Error", message: "Camera is not found in this device")
            }
            
        }
        let gallery = UIAlertAction(title: "Photo Gallery", style: .default) { (action) in
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cameraAction.setValue(UIImage(systemName: "camera"), forKey: "image")
        gallery.setValue(UIImage(systemName: "photo"), forKey: "image")
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true)
    }
    
    func presentVideoActionSheet() {
        let actionSheet = UIAlertController(title: "Choose Photo Source", message: "", preferredStyle: .actionSheet)
        let picker = UIImagePickerController()
        picker.delegate = self
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.mediaTypes = ["public.movie"]
                picker.allowsEditing = true
                picker.videoQuality = .typeMedium
                self.present(picker, animated: true, completion: nil)
            }else {
                self.showAlert(title: "Error", message: "Camera is not found in this device")
            }
            
        }
        let gallery = UIAlertAction(title: "library", style: .default) { (action) in
            picker.mediaTypes = ["public.movie"]
            picker.allowsEditing = true
            picker.videoQuality = .typeMedium
            self.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        cameraAction.setValue(UIImage(systemName: "camera"), forKey: "image")
        gallery.setValue(UIImage(systemName: "video"), forKey: "image")
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true)
    }
    
    func getAllConversations() {
        guard let userId = UserDefaults.standard.string(forKey: "UserId") else {
            return
        }
        guard otherId != "" else {
            return
        }
        var conversations = [DataModel]()
        var convData = DataModel(message: "", is_read: false, to_id: "", from_id: "", type: "", message_id: "", sent_date: FirebaseFirestore.Timestamp(date: Date()),image_url: "",video_url: "",latitude: 0,longitude: 0)
        self.db.collection("Messages").whereField("from_id", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error:", error.localizedDescription as Any)
            }
            guard let snapshot = snapshot else {
                return
            }
            for document in snapshot.documents  {
                if let data = document.data() as? [String: Any] {
                    if let toId = data["to_id"] as? String {
                        if toId == self.otherId {
                            convData.to_id = toId
                            if let message = data["message"] as? String {
                                convData.message = message
                            }
                            if let imageUrl = data["image_url"] as? String {
                                convData.image_url = imageUrl
                            }
                            if let type = data["type"] as? String {
                                convData.type = type
                            }
                            if let sentDate = data["sent_date"] as? Timestamp {
                                convData.sent_date = sentDate
                            }
                            if let videoUrl = data["video_url"] as? String {
                                convData.video_url = videoUrl
                            }
                            if let isRead = data["is_read"] as? Bool {
                                convData.is_read = isRead
                            }
                            if let msgId = data["message_id"] as? String {
                                convData.message_id = msgId
                            }
                            if let latitude = data["latitude"] as? Double {
                                convData.latitude = latitude
                            }
                            if let longitude = data["longitude"] as? Double {
                                convData.longitude = longitude
                            }
                            conversations.append(convData)
                        }else {
                         
                        }
                        
                    }
                }
            }
            if conversations.count != 0 {
                for conv in conversations {
                    if conv.image_url != "" {
                        do {
                            let imageData = try Data(contentsOf: URL(string: conv.image_url)!)
                            self.messages.append(Message(sentDate: conv.sent_date.dateValue(), sender: self.sender, messageId: conv.message_id, kind: MessageKind.photo(Media(url: URL(string: conv.image_url), image: UIImage(data: imageData), placeholderImage: UIImage(data: imageData) ?? UIImage(), size: CGSize(width: 300, height: 300))), isRead: conv.is_read, type: conv.type, toId: conv.to_id, fromId: conv.from_id))
                        }catch {
                            print("Failed to get Image Url")
                        }
                    }else if conv.video_url != "" {
                        //do {
                        guard let videoUrl = URL(string: conv.video_url) else {
                            return
                        }
                        let imageData = self.generateThumnail(url: videoUrl)
                        self.messages.append(Message(sentDate: conv.sent_date.dateValue(), sender: self.sender, messageId: conv.message_id, kind: MessageKind.video(Media(url: URL(string: conv.video_url), image: imageData ?? UIImage(), placeholderImage: imageData ?? UIImage(), size: CGSize(width: 250, height: 250))), isRead: conv.is_read, type: conv.type, toId: conv.to_id, fromId: conv.from_id))
//                        }catch {
//                            print("Failed to get Image Url")
//                        }
                    }else if conv.latitude != 0 && conv.longitude != 0 {
                        let item = Location(location: CLLocation(latitude: conv.latitude, longitude: conv.longitude), size: CGSize(width: 250, height: 250))
                        self.messages.append(Message(sentDate: conv.sent_date.dateValue(), sender: self.sender, messageId: conv.message_id, kind: MessageKind.location(item), isRead: conv.is_read, type: conv.type, toId: conv.to_id, fromId: conv.from_id))
                    }
                    
                    else {
                    self.messages.append(Message(sentDate: conv.sent_date.dateValue(), sender: self.sender, messageId: conv.message_id, kind: MessageKind.text(conv.message), isRead: conv.is_read, type: conv.type, toId: conv.to_id, fromId: conv.from_id))
                    }
                    DispatchQueue.main.async {
                        self.messages = self.messages.sorted(by: {$0.sentDate.compare($1.sentDate) == .orderedAscending })
                        self.messagesCollectionView.reloadData()
                    }
                }
                
            }else {
                //show no messages label
            }
        }
       
    }
}




extension ConversationsViewController:  MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate {
    
func currentSender() -> SenderType {
    return self.sender
   }

   func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
       return messages.count
   }

   func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
       return messages[indexPath.section]
   }

   func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
       if indexPath.section % 3 == 0 {
           return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
       }
       return nil
   }

   func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
       return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
   }

   func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
       let name = message.sender.displayName
       return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
   }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
   
   
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in  messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        let borderColor:UIColor = isFromCurrentSender(message: message) ? .orange: .clear
       // return .bubbleTailOutline(borderColor, corner, .curved)
        return MessageStyle.bubbleTail(corner, .curved)
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        if sender.senderId == sender.senderId {
           // avatarView.set(avatar: Avatar(image: <#T##UIImage?#>, initials: <#T##String#>))
        }else {
            
        }
    }
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

// MARK: - MessageCellDelegate
extension ConversationsViewController: MessageCellDelegate {
    
   func didTapAvatar(in cell: MessageCollectionViewCell) {
       print("Avatar tapped")
   }
   
   func didTapMessage(in cell: MessageCollectionViewCell) {
       print("Message tapped")
    guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
        return
    }
    
    let message = messages[indexPath.section]
    switch message.kind {
    
    case .text(let text):
        print(text)
        
    case .attributedText(_):
        break
    case .photo(_):
        break
    case .video(_):
        break
    case .location(let locationItem):
        let coordinate = CLLocationCoordinate2D(latitude: locationItem.location.coordinate.latitude, longitude: locationItem.location.coordinate.longitude)
        let pickerVC = LocationPickerViewController(coordinates: coordinate)
        pickerVC.isPickable = false
        navigationController?.pushViewController(pickerVC, animated: true)
    case .emoji(_):
        break
    case .audio(_):
        break
    case .contact(_):
        break
    case .linkPreview(_):
        break
    case .custom(_):
        break
    }
    
    
   }
   
   func didTapImage(in cell: MessageCollectionViewCell) {
       print("Image tapped")
    guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
        return
    }
    let message = messages[indexPath.section]
    switch message.kind {
    case .photo(let photo):
        guard let img = photo.image else {
            return
        }
        setupImageView(img: img)
    case .video(let item):
        guard let url = item.url else {
            return
        }
        let videoPlayer = AVPlayerViewController()
        player = AVPlayer(url: url)
        videoPlayer.player = player
        self.present(videoPlayer, animated: true, completion: nil)
    default:
        break
    }
   }
   
   func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
       print("Top cell label tapped")
   }
   
   func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
       print("Bottom cell label tapped")
   }
   
   func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
       print("Top message label tapped")
   }
   
   func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
       print("Bottom label tapped")
   }

    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            print("Failed to identify message when audio cell receive tap gesture")
            return
        }
    }

   func didStartAudio(in cell: AudioMessageCell) {
       print("Did start playing audio sound")
   }

   func didPauseAudio(in cell: AudioMessageCell) {
       print("Did pause audio sound")
   }

   func didStopAudio(in cell: AudioMessageCell) {
       print("Did stop audio sound")
   }

   func didTapAccessoryView(in cell: MessageCollectionViewCell) {
       print("Accessory view tapped")
   }
   

}

// MARK: - MessageLabelDelegate
extension ConversationsViewController: MessageLabelDelegate {
   func didSelectAddress(_ addressComponents: [String: String]) {
       print("Address Selected: \(addressComponents)")
   }
   
   func didSelectDate(_ date: Date) {
       print("Date Selected: \(date)")
   }
   
   func didSelectPhoneNumber(_ phoneNumber: String) {
       print("Phone Number Selected: \(phoneNumber)")
   }
   
   func didSelectURL(_ url: URL) {
       print("URL Selected: \(url)")
   }
   
   func didSelectTransitInformation(_ transitInformation: [String: String]) {
       print("TransitInformation Selected: \(transitInformation)")
   }

   func didSelectHashtag(_ hashtag: String) {
       print("Hashtag selected: \(hashtag)")
   }

   func didSelectMention(_ mention: String) {
       print("Mention selected: \(mention)")
   }

   func didSelectCustom(_ pattern: String, match: String?) {
       print("Custom data detector patter selected: \(pattern)")
   }
}

// MARK: - MessageInputBarDelegate
extension ConversationsViewController: InputBarAccessoryViewDelegate {
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        
        
        let components = inputBar.inputTextView.text ?? ""
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "write a message..."
                if components != "" {
                    self?.insertNewMessage(message: components)
                }
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if messageInputBar.inputTextView.text == "" {
            let sendBtn = InputBarSendButton(frame: CGRect(x: 0,y: 0, width: 30, height: 30))
            let config = UIImage.SymbolConfiguration(scale: .large)
            sendBtn.setImage(UIImage(systemName: "mic.circle",withConfiguration: config), for: .normal)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            messageInputBar.setStackViewItems([sendBtn], forStack: .right, animated: false)
            sendBtn.onTouchUpInside { (btn) in
                self.setupAudioRecorder()
            }
        }else {
            let sendBtn = InputBarSendButton(frame: CGRect(x: 0,y: 0, width: 30, height: 30))
            sendBtn.setImage(UIImage(systemName: "location.fill"), for: .normal)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            messageInputBar.setStackViewItems([sendBtn], forStack: .right, animated: false)
            sendBtn.onTouchUpInside { (btn) in
                self.sendBtnTapped()
            }
        }
    }
    
}

/// Image Picker Delegate Methods
extension ConversationsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            StorageManager.shared.uploadImageInFirebaseStorage(image: selectImage) { (imageUrl, image) in
                self.insertImageMessageInDatabase(imageUrl: imageUrl, image: image)
            }
        }
        
        if let selectedUrl = info[.mediaURL] as? URL {
            print(selectedUrl,"Video url")
            StorageManager.shared.uploadVideoInFirebaseStorage(url: selectedUrl) { (url) in
                self.insertVideoMessageInDatabase(videoUrl: url)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true)
    }
    
    private func setupImageView(img: UIImage) {
        imageView.isHidden = false
        view.addSubview(imageView)
        imageView.frame = view.bounds
        imageView.image = img
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismiss() {
        imageView.isHidden = true
    }
    
    func generateThumnail(url : URL) -> UIImage?{
        guard let videoUrl = url as? URL else {
            return nil
        }
        let asset: AVAsset = AVAsset(url: videoUrl)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time        : CMTime = CMTimeMake(value: 1, timescale: 30)
        let img         : CGImage
        do {
            try img = assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg: UIImage = UIImage(cgImage: img)
            return frameImg
        } catch {
         print("Failed to get Thumbnail Image")
        }
        return nil
    }
}

extension ConversationsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls.first as Any)
        self.dismiss(animated: true, completion: nil)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ConversationsViewController: IQAudioRecorderViewControllerDelegate {
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        print(filePath)
    }
    
    
}




class AudioViewController {
    var delegate: IQAudioRecorderViewControllerDelegate
    
    init(delegate_: IQAudioRecorderViewControllerDelegate) {
        delegate = delegate_
    }
    func presentAudioRecorder(target: UIViewController) {
        
        let controller = IQAudioRecorderViewController()
        controller.delegate = delegate
        controller.title = "Record"
        controller.maximumRecordDuration = 120
        controller.allowCropping = true
        target.presentBlurredAudioRecorderViewControllerAnimated(controller)
    }
}
