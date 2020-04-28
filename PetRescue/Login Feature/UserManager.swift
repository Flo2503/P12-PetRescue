//
//  UsersManager.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//  swiftlint:disable void_return

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserManager {

    static func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if let err = error {
                callback?(err)
                return
            }
            callback?(nil)
        }
    }

    static func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let err = error {
                callback?(err)
                return
            }
            callback?(nil)
        }
    }

    static func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }

    static func sendMailVerification(_ callback: ((Error?) -> ())? = nil) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            callback?(error)
        })
    }

    static func reloadUser(_ callback: ((Error?) -> ())? = nil) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }

    static func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
}
