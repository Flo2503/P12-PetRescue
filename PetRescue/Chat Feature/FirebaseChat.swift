//
//  FirebaseChat.swift
//  PetRescue
//
//  Created by Flo on 10/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseChat {
    var currentUser = Auth.auth().currentUser?.uid

    var user2Name: String?
    var user2ImgUrl: String?
    var user2UID: String?

    private var docReference: DocumentReference?

    var messages: [Message] = []

    func createNewChat(user2Id: String) {
        let users = [self.currentUser, user2Id]
        let data: [String: Any] = ["users": users]
        let database = Firestore.firestore().collection("Chats")
        database.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
               print("something")
            }
        }
    }
/*
    func loadChat(user2Id: String) {
        self.user2UID = user2Id
        //Fetch all the chats which has current user in it
        let database = Firestore.firestore().collection("Chats")
                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        database.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    self.createNewChat()
                } else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(self.user2UID!))! {
                            self.docReference = doc.reference
                            //fetch it's thread collection
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.messages.removeAll()
                                    for message in threadQuery!.documents {

                                        let msg = Message(dictionary: message.data())
                                        self.messages.append(msg!)
                                        print("Data: \(msg?.content ?? "No message found")")
                                    }
                            }
                            })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }*/

}
