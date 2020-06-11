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

    private static var currentUser: UserManager?
    private static let storage = Storage.storage()
    private static let dataBase = Database.database()
    let name: String
    let firstName: String
    let emailAddress: String
    var userPicture: String

    init(name: String, firstName: String, emailAdress: String, userPicture: String) {
        self.name = name
        self.firstName = firstName
        self.emailAddress = emailAdress
        self.userPicture = userPicture
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let firstName = value["firstName"] as? String,
            let emailAddress = value["emailAddress"] as? String,
            let userPicture = value["userPicture"] as? String else {
                return  nil
        }
        self.name = name
        self.firstName = firstName
        self.emailAddress = emailAddress
        self.userPicture = userPicture
    }

    static func createUser(email: String, password: String, name: String, firstName: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, success) in
            if success != nil {
                callback(false)
                return
            } else {
                let ref = Database.database().reference()
                if let userID = Auth.auth().currentUser?.uid {
                    ref.child("users").child(userID).setValue(["name": name, "firstName": firstName, "emailAddress": email, "userPicture": ""])
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

    static func sendPasswordReset(withEmail email: String, callback: @escaping (Bool) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { success in
            if success != nil {
                callback(false)
                return
            }
            callback(true)

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

    static func uploadUserPicture(image: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        if let userId = Auth.auth().currentUser?.uid {
            let storageRef = storage.reference().child("usersPictures").child(userId).child("userPic.png")
            if let uploadData = image.jpegData(compressionQuality: 0.5) {
                storageRef.putData(uploadData, metadata: nil) { (_, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        completion(false)
                    } else {
                        UserManager.downloadUrl()
                        completion(true)
                    }
                }
            }
        }
    }

    static func retrieveUserImage(url: String, callback: @escaping (_ image: UIImage?) -> Void) {
        let reference = storage.reference(forURL: url)
        reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if let error = error {
                print("Error while retreiving image from firebase, url = \(url).")
                print("Error description: \(error.localizedDescription.debugDescription)")
                callback(nil)
            } else if let data = data {
                callback(UIImage(data: data))
            } else {
                print("Error while retreiving image from firebase, url = \(url). Caused by nil data.")
                callback(nil)
            }
        }
    }

    static func downloadUrl() {
        print("called")
        if let userId = Auth.auth().currentUser?.uid {
            let storageRef = storage.reference().child("usersPictures").child(userId).child("userPic.png")
            let ref = dataBase.reference()
            storageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Error description: \(error.localizedDescription.debugDescription)")
                } else {
                    if let url = url?.absoluteString {
                        UserManager.currentUser?.userPicture = url
                        ref.child("users").child(userId).updateChildValues(["userPicture": url])
                    }
                }
            })
        }
    }
}
