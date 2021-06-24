//
//  EditProfileTableViewCell.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 17/05/21.
//

import UIKit

protocol EditProfileFormDelegate {
  func formTableViewCell(_ cell: EditProfileTableViewCell, didUpdateModel model: EditProfileFormModel)
}

class EditProfileTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "EditProfileTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let formTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        return textField
    }()
    
    public var model: EditProfileFormModel?
    
    public var delegate: EditProfileFormDelegate? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(formTextField)
        selectionStyle = .none
        formTextField.delegate = self 
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width / 3, height: contentView.frame.size.height)
        formTextField.frame = CGRect(x: label.right + 5, y: 0, width: contentView.frame.size.width - 10 - label.frame.size.width, height: contentView.frame.size.height)
    }
    
    public func configureModels(model: EditProfileFormModel) {
        self.model = model
        label.text = model.label
        formTextField.placeholder = model.placeHolder
        formTextField.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        formTextField.placeholder = nil
        formTextField.text = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = self.model else {
            return true
        }
        formTextField.resignFirstResponder()
        delegate?.formTableViewCell(self, didUpdateModel: model)
        return true
    }
}
