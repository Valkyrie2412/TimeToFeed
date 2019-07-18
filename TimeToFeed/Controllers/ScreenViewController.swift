//
//  ScreenViewController.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/16/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//


import UIKit
import FirebaseAuth


class ScreenViewController: UIViewController {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Welcome to my app"
        
        subtitleLabel.text = "It's time to feed :)"
        
        loginButton.setTitle("Log in", for: .normal)
       
        signUpButton.setTitle("Sign Up", for: .normal)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if Auth.auth().currentUser != nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabbarController
//            self.navigationController?.pushViewController(controller, animated: true)
//        } else {
//            self.present(self, animated: true, completion: nil)
//        }
//    }
  
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let signUpVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    

}

