//
//  People.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/17/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import UIKit
import Contacts

class People {
    let firstName: String
    let lastName: String
    let email: String
    var identifier: String?
    var profilePicture: UIImage?
    var storedContact: CNMutableContact?
    var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?
    
    init(firstName: String, lastName: String, email: String, profilePicture: UIImage?){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePicture = profilePicture
    }
    
    static func defaultContacts() -> [People] {
        return [
            People(firstName: "Cheesy", lastName: "Cat", email: "aa12@gmail.com", profilePicture: UIImage(named: "1")),
            People(firstName: "Freckles", lastName: "Dog", email: "bb12@gmail.com", profilePicture: UIImage(named: "2")),
            People(firstName: "Maxi", lastName: "Dog", email: "cc12@gmail.com", profilePicture: UIImage(named: "3")),
            People(firstName: "Shippo", lastName: "Dog", email: "dd12@gmail.com", profilePicture: UIImage(named: "4"))]
    }
}

extension People: Equatable {
    static func ==(lhs: People, rhs: People) -> Bool{
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.email == rhs.email &&
            lhs.profilePicture == rhs.profilePicture
    }
}

extension People {
    var contactValue: CNContact {
        let contact = CNMutableContact()
        contact.givenName = firstName
        contact.familyName = lastName
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: email as NSString)]
        if let profilePicture = profilePicture {
            let imageData = profilePicture.jpegData(compressionQuality: 1)
            contact.imageData = imageData
        }
        if let phoneNumberField = phoneNumberField {
            contact.phoneNumbers.append(phoneNumberField)
        }
        return contact.copy() as! CNContact
    }
    
    convenience init?(contact: CNContact) {
        guard let email = contact.emailAddresses.first else { return nil }
        let firstName = contact.givenName
        let lastName = contact.familyName
        let workEmail = email.value as String
        var profilePicture: UIImage?
        if let imageData = contact.imageData {
            profilePicture = UIImage(data: imageData)
        }
        self.init(firstName: firstName, lastName: lastName, email: workEmail, profilePicture: profilePicture)
        if let contactPhone = contact.phoneNumbers.first {
            phoneNumberField = contactPhone
        }
    }
}
