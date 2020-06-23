//
//  UsersManager.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//  swiftlint:disable void_return

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserManager {

    // MARK: - Properties, instances
    private var user: User?
    private var users: [User]?
    private let storage = Storage.storage()
    private let dataBase = Database.database()
    static let currentUserId = Auth.auth().currentUser?.uid

    // MARK: - Firebase Methods
    ///Create user on Firebase Database and create user on Firebase authentification with password and email
    func createUser(email: String, password: String, name: String, firstName: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, success) in
            if success != nil {
                callback(false)
                return
            } else {
                let ref = Database.database().reference()
                if let userID = Auth.auth().currentUser?.uid {
                    ref.child("users").child(userID).setValue(["name": name, "firstName": firstName, "emailAddress": email, "userId": userID])
                }
            }
            callback(true)
        }
    }

    ///Log in on Firebase with emaild and password
    func login(withEmail email: String, password: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, success) in
            if success != nil {
                callback(false)
                return
            }
            callback(true)
        }
    }

    ///Allow to logout on firebase. Return true when done
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }

    ///Allow to retrieve user information observing path on Firebase: users/userId
    func retrieveUser(callback: @escaping (_ currentUser: User) -> Void) {
        let ref = Database.database().reference()
        if let userId = Auth.auth().currentUser?.uid {
            let path = ref.child("users").child(userId)
            path.observe(.value, with: { snapshot in
                if let user = User(snapshot: snapshot) {
                    self.user = user
                    callback(user)
                }
            })
        }
    }

    ///Allow to retrieve second user information observing path on Firebase: users/userId
    func retrieveChatUser(userChatId: String, callback: @escaping (_ chatUser: User) -> Void) {
        let ref = Database.database().reference()
        let path = ref.child("users").child(userChatId)
        path.observe(.value, with: { snapshot in
            if let user = User(snapshot: snapshot) {
                self.user = user
                callback(user)
            }
        })
    }

    ///Send an email to the user to reset his password
    func sendPasswordReset(withEmail email: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { success in
            if success != nil {
                callback(false)
                return
            }
            callback(true)

        }
    }

    ///Allow to change password on Firebase Database
    func updatePassword(password: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: password) { success in
            if success != nil {
                callback(false)
                return
            }
            callback(true)
        }
    }

    /// Allow to edit email on FIrebase database
    func updateEmail(email: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().currentUser?.updateEmail(to: email) { success in
            if success != nil {
                callback(false)
                return
            } else {
                let ref = self.dataBase.reference()
                if let userID = Auth.auth().currentUser?.uid {
                    ref.child("users").child(userID).updateChildValues(["emailAddress": email])
                }
            }
            callback(true)
        }
    }
}
