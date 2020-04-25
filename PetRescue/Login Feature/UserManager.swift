//
//  UsersManager.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserManager {

    func createUser(email: String, password: String, _ callback:((Error?) -> ())? = nil) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let e = error {
                callback?(e)
                return
            }
            callback?(nil)
        }
    }
    
    func login(withEmail email: String, password: String, _ callback:((Error?) -> ())? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let e = error {
                callback?(e)
                return
            }
            callback?(nil)
        }
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}
