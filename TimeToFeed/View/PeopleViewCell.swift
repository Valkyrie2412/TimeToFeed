//
//  PeopleViewCell.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/17/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import UIKit
import Contacts

class PeopleViewCell: UITableViewCell {
    @IBOutlet private weak var contactNameLabel: UILabel!
    @IBOutlet private weak var contactEmailLabel: UILabel!
    @IBOutlet private weak var contactImageView: UIImageView! 
      
    
    var people : People? {
        didSet {
            configureCell()
        }
    }
    
    private func configureCell() {
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        guard let people = people,
            let name = formatter.string(from: people.contactValue) else { return }
        contactNameLabel.text = name
        contactEmailLabel.text = people.email
        contactImageView.image = people.profilePicture ?? UIImage(named: "PlaceholderProfilePic")
    }
}

