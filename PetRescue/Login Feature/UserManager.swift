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

struct UserManager {
    // MARK: - Properties, instances
    private static var currentUser: UserManager?
    private static let storage = Storage.storage()
    private static let dataBase = Database.database()
    static let currentConnectedUser = Auth.auth().currentUser?.uid
    let name: String
    let firstName: String
    let emailAddress: String
    // MARK: - Init
    init(name: String, firstName: String, emailAdress: String) {
        self.name = name
        self.firstName = firstName
        self.emailAddress = emailAdress
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let firstName = value["firstName"] as? String,
            let emailAddress = value["emailAddress"] as? String else {
                return  nil
        }
        self.name = name
        self.firstName = firstName
        self.emailAddress = emailAddress
    }
    // MARK: - Firebase Methods
    ///Create user on Firebase Database and create user on Firebase authentification with password and email
    static func createUser(email: String, password: String, name: String, firstName: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, success) in
            if success != nil {
                callback(false)
                return
            } else {
                let ref = Database.database().reference()
                if let userID = Auth.auth().currentUser?.uid {
                    ref.child("users").child(userID).setValue(["name": name, "firstName": firstName, "emailAddress": email])
                }
            }
            callback(true)
        }
    }
    ///Log in on Firebase with emaild and password
    static func login(withEmail email: String, password: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, success) in
            if success != nil {
                callback(false)
                return
            }
            callback(true)
        }
    }
    ///Allow to logout on firebase. Return true when done
    static func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    ///Allow to retrieve user information observing path on Firebase: users/userId
    static func retrieveUser(callback: @escaping (_ currentUser: UserManager) -> Void) {
        let ref = Database.database().reference()
        if let userId = Auth.auth().currentUser?.uid {
            let path = ref.child("users").child(userId)
            path.observe(.value, with: { snapshot in
                if let user = UserManager(snapshot: snapshot) {
                    UserManager.currentUser = user
                    callback(user)
                }
            })
        }
    }
    ///Allow to retrieve second user information observing path on Firebase: users/userId
    static func retrieveChatUser(userChatId: String, callback: @escaping (_ currentUser: UserManager) -> Void) {
        let ref = Database.database().reference()
        let path = ref.child("users").child(userChatId)
        path.observe(.value, with: { snapshot in
            if let user = UserManager(snapshot: snapshot) {
                UserManager.currentUser = user
                callback(user)
            }
        })
    }
    ///Send an email to the user to reset his password
    static func sendPasswordReset(withEmail email: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { success in
            if success != nil {
                callback(false)
                return
            }
            callback(true)

        }
    }
    ///Allow to change password on Firebase Database
    static func updatePassword(password: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: password) { success in
            if success != nil {
                callback(false)
                return
            }
            callback(true)
        }
    }
    /// Allow to edit email on FIrebase database
    static func updateEmail(email: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().currentUser?.updateEmail(to: email) { success in
            if success != nil {
                callback(false)
                return
            } else {
                let ref = dataBase.reference()
                if let userID = Auth.auth().currentUser?.uid {
                    ref.child("users").child(userID).updateChildValues(["emailAddress": email])
                }
            }
            callback(true)
        }
    }
}
