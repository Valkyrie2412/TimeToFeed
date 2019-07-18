//
//  FirebaseAuthManager.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/16/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import FirebaseAuth
import UIKit

class FirebaseAuthManager {
    
    func login(credential: AuthCredential, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
            print(firebaseUser)
            completionBlock(error == nil)
        })
    }
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                print(result)
                completionBlock(true)
            }
        }
    }
}
