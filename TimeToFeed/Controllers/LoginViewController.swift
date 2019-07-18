//
//  LoginViewController.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/16/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var contactPointTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var separatorLabel: UILabel!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    let readPermissions: [Permission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Log In"
        
        contactPointTextField.placeholder = "E-mail"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true
        
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true
        
        separatorLabel.text = "OR"
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        facebookButton.setTitle("Facebook Login", for: .normal)
        facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @IBAction func didTapBackButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapLoginButton() {
        let loginManager = FirebaseAuthManager()
        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        if password.count >= 8 {
            loginManager.signIn(email: email, pass: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "Logged in was sucessfully."
                } else {
                    message = "There was an error."
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabbarController
                    self.navigationController?.pushViewController(controller, animated: true)

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
    
        @objc func didTapFacebookButton() {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
        }
    
        private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
            switch loginResult {
            case .success:
                didLoginWithFacebook()
            case .failed(_): break
            default: break
            }
        }
    
        fileprivate func didLoginWithFacebook() {
            // Successful log in with Facebook
            if let accessToken = AccessToken.current {
                // If Firebase enabled, we log the user into Firebase
                FirebaseAuthManager().login(credential: FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)) {[weak self] (success) in
                    guard let `self` = self else { return }
                    var message: String = ""
                    if (success) {
                        message = "Logged in was sucessfully."
                    } else {
                        message = "There was an error."
                    }
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabbarController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }))
                    self.display(alertController: alertController)
                }
            }
        }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
}

