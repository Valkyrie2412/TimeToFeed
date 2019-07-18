//
//  EditInfoViewController.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/18/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//
import UIKit
import Contacts

class EditInfoViewController: UITableViewController {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneTypeLabel: UILabel!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var photoImage: UIImageView!
    
    var people: People?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        guard let people = people else {
            nameLabel.text = ""
            emailLabel.text = ""
            photoImage.image = UIImage(named: "Logo")
            phoneTextField.text = ""
            phoneTextField.isEnabled = false
            return
        }
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        if let name = formatter.string(from: people.contactValue) {
            nameLabel.text = name
        } else {
            nameLabel.text = "Name Not Available"
        }
        emailLabel.text = people.email
        photoImage.image = people.profilePicture
        if let phoneNumberField = people.phoneNumberField,
            let label = phoneNumberField.label {
            phoneTypeLabel.text = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
            phoneTextField.text = phoneNumberField.value.stringValue
        }
    }
    
    @IBAction private func save(_ sender: Any) {
        phoneTextField.resignFirstResponder()
        let store = CNContactStore()
        guard
            let people = people,
            let phoneNumberText = phoneTextField.text
            else { return }
        let phoneNumberValue = CNPhoneNumber(stringValue: phoneNumberText)
        let saveRequest = CNSaveRequest()
        
        if let storedContact = people.storedContact,
            let phoneNumberToEdit = storedContact.phoneNumbers.first(
                where: { $0 == people.phoneNumberField }
            ),
            let index = storedContact.phoneNumbers.firstIndex(of: phoneNumberToEdit) {
     
            let newPhoneNumberField = phoneNumberToEdit.settingValue(phoneNumberValue)
            storedContact.phoneNumbers.remove(at: index)
            storedContact.phoneNumbers.insert(newPhoneNumberField, at: index)
            people.phoneNumberField = newPhoneNumberField
      
            saveRequest.update(storedContact)
            people.storedContact = nil
        } else if let unsavedContact = people.contactValue.mutableCopy() as? CNMutableContact {
       
            let phoneNumberField = CNLabeledValue(label: CNLabelPhoneNumberMain,
                                                  value: phoneNumberValue)
            unsavedContact.phoneNumbers = [phoneNumberField]
            people.phoneNumberField = phoneNumberField
      
            saveRequest.add(unsavedContact, toContainerWithIdentifier: nil)
        }
        
        do {
            try store.execute(saveRequest)
            let controller = UIAlertController(title: "Success",
                                               message: nil,
                                               preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default))
            present(controller, animated: true)
            setup()
        } catch {
            print(error)
        }
    }
}
