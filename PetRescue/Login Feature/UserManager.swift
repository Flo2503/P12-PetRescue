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

struct UserManager {

    private static var currentUser: UserManager?
    let name: String
    let firstName: String
    let emailAddress: String

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

    static func login(withEmail email: String, password: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, success) in
            if success != nil {
                callback(false)
                return
            }
            callback(true)
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

    static func retrieveUser(userId: String, callback: @escaping (_ currentUser: UserManager) -> Void) {
        let ref = Database.database().reference()
        let path = ref.child("users").child(userId)
        path.observe(.value, with: { snapshot in
            if let user = UserManager(snapshot: snapshot) {
                UserManager.currentUser = user
                callback(user)
            }
        })
    }

    static func sendPasswordReset(withEmail email: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { _ in
            callback(false)
        }
    }

    static func updatePassword(password: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: password) { success in
            if success != nil {
                callback(false)
                return
            }
            callback(true)
        }
    }

    static func updateEmail(email: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().currentUser?.updateEmail(to: email) { _ in
            callback(false)
        }
    }

}
