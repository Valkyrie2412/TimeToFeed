//
//  PeopleViewController.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/17/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import UIKit
import ContactsUI


class PeopleViewController: UITableViewController {
    
    var peopleList = People.defaultContacts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false   
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            if segue.identifier == "EditInfo",
    
                let cell = sender as? PeopleViewCell,
                let indexPath = tableView.indexPath(for: cell),
                let editViewController = segue.destination as? EditInfoViewController {
                let people = peopleList[indexPath.row]
    
                let store = CNContactStore()
    
                let predicate = CNContact.predicateForContacts(matchingEmailAddress: people.email)
                let keys = [CNContactPhoneNumbersKey as CNKeyDescriptor]
    
                if let contacts = try? store.unifiedContacts(matching: predicate, keysToFetch: keys),
                    let contact = contacts.first,
                    let contactPhone = contact.phoneNumbers.first {
                    people.storedContact = contact.mutableCopy() as? CNMutableContact
                    people.phoneNumberField = contactPhone
                    people.identifier = contact.identifier
                }
                editViewController.people = people
    
//                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.tabbarCustom?.selectedIndex = 1
            }
        }
    
 
    
    @IBAction private func addFriends(sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(
            format: "@sum.items.price < 1000")
        present(contactPicker, animated: true, completion: nil)
        
    }
    
}

//MARK: - UITableViewDataSource
extension PeopleViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath)
        
        if let cell = cell as? PeopleViewCell {
            let people = peopleList[indexPath.row]
            cell.people = people
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension PeopleViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let people = peopleList[indexPath.row]
        let contact = people.contactValue

        let contactViewController = CNContactViewController(forUnknownContact: contact)
        contactViewController.hidesBottomBarWhenPushed = true
        contactViewController.allowsEditing = true
        contactViewController.allowsActions = true

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1940518618, green: 0.5191689134, blue: 1, alpha: 1)
        navigationController?.pushViewController(contactViewController, animated: true)
        
    }
}

//MARK: - CNContactPickerDelegate
extension PeopleViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contacts: [CNContact]) {
        let newPersons = contacts.compactMap { People(contact: $0) }
        for person in newPersons {
            if !peopleList.contains(person) {
                peopleList.append(person)
            }
        }
        tableView.reloadData()
    }
}

