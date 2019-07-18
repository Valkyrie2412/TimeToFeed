//
//  SignUpViewController.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/16/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var lblPasswordValidation: UILabel!
    @IBOutlet var signUpButton: UIButton!
    
    var isPasswordValid = true

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        titleLabel.text = "Sign Up"
        
        nameTextField.placeholder = "Full Name"
        nameTextField.clipsToBounds = true
        
        emailTextField.placeholder = "E-mail Address"
        emailTextField.clipsToBounds = true
        
        
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.clipsToBounds = true
        
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clipsToBounds = true
     
        
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        let attrStr = NSMutableAttributedString (
            string: "Password must be at least 8 characters.",
            attributes: [
                .font: UIFont.init(name: "Roboto", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0),
                .foregroundColor: UIColor.black
            ])
        
        if let txt = passwordTextField.text {
            isPasswordValid = true
            attrStr.addAttributes(setupAttributeColor(if: (txt.count >= 8)),
                                  range: findRange(in: attrStr.string, for: "at least 8 characters"))
        } else {
            isPasswordValid = false
        }
        
        lblPasswordValidation.attributedText = attrStr
    }
    
    // MARK: - In-Place Validation Helpers
    func setupAttributeColor(if isValid: Bool) -> [NSAttributedString.Key: Any] {
        if isValid {
            return [NSAttributedString.Key.foregroundColor: UIColor.green]
        } else {
            isPasswordValid = false
            return [NSAttributedString.Key.foregroundColor: UIColor.red]
        }
    }
    
    func findRange(in baseString: String, for substring: String) -> NSRange {
        if let range = baseString.localizedStandardRange(of: substring) {
            let startIndex = baseString.distance(from: baseString.startIndex, to: range.lowerBound)
            let length = substring.count
            return NSMakeRange(startIndex, length)
        } else {
            print("Range does not exist in the base string.")
            return NSMakeRange(0, 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapSignUpButton() {
        let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            if password.count >= 8 {
                signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                    guard let `self` = self else { return }
                    var message: String = ""
                    if (success) {
                        message = "Created account was sucessfully."
                    } else {
                        message = "There was an error."
                    }
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }))
                    self.display(alertController: alertController)
                }
            } else {
                let message = "Error!"
                let myAlert = UIAlertController(title: message, message: "Password less than 8, please check for password again =)))))", preferredStyle: .alert)
                let myOkAction = UIAlertAction(title: "OK", style: .default) { _ in
                }
                myAlert.addAction(myOkAction)
                self.present(myAlert, animated: true, completion: nil)
            }
        }
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }

}
