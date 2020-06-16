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

class ChatManager {

    private var currentUserId = Auth.auth().currentUser?.uid
    private let chatDatabase = Firestore.firestore().collection("Chats")
    private var docReference: DocumentReference?
    var timeStamp = Timestamp()

    private var messages: [Message] = []

    func createNewChat(user2: String) {
        let users = [currentUserId, user2]
        let data: [String: Any] = ["users": users]
        let database = chatDatabase
        database.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat(user2: user2, callback: { msg in
                    self.messages = msg
                })
            }
        }
    }

    func loadChat(user2: String, callback: @escaping (_ msg: [Message]) -> Void) {
        //Fetch all the chats which has current user in it
        let database = chatDatabase.whereField("users", arrayContains: currentUserId!)
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
                    self.createNewChat(user2: user2)
                } else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(user2))! {
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
                                var retreiveMessages: [Message] = []
                                for message in threadQuery!.documents {
                                    print("****\(threadQuery?.documents.description ?? "nothing to display")*****")
                                    if let storedMessage = Message(dictionary: message.data()) {
                                        retreiveMessages.append(storedMessage)
                                        print("Data: \(storedMessage.content)")
                                    } else {
                                        print("***Error trying retreive messages***")
                                    }
                                }
                                callback(retreiveMessages)
                            }
                            })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat(user2: user2)
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }

    /*func loadChat(user2: String, callback: @escaping (_ messages: [Message]) -> Void) {
        getChat(callback: { currentUserDocuments in
            if let userDocuments = currentUserDocuments {
                for doc in userDocuments {
                    let chat = Chat(dictionary: doc.data())
                    if (chat?.users.contains(user2))! {
                        self.docReference = doc.reference
                        doc.reference.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                if let error = error {
                                    print("Error: \(error)")
                                    return
                                } else {
                                    self.messages.removeAll()
                                    guard let queryDocuments = threadQuery?.documents else { return }
                                    var allMessages: [Message] = []
                                    for message in queryDocuments {
                                        if let msg = Message(dictionary: message.data()) {
                                            allMessages.append(msg)
                                            callback(allMessages)
                                            print("Data: \(msg.content)")
                                        }
                                    }
                                }
                            })
                        return
                    }
                }
                self.createNewChat(user2: user2)
            } else {
                self.createNewChat(user2: user2)
            }
        })
    }

    func getChat(callback: @escaping (_ currentUserDocuments: [QueryDocumentSnapshot]?) -> Void) {
        guard let userId = currentUserId else { return }
        let database = chatDatabase.whereField("users", arrayContains: userId)
        database.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else { return }
                if queryCount >= 1 {
                    let querySnap  = chatQuerySnap?.documents
                    var chatDocuments = [QueryDocumentSnapshot]()
                    for chats in [querySnap] {
                        guard let chats = chats else { return }
                        chatDocuments.append(contentsOf: chats)
                    }
                    callback(chatDocuments)
                }
            }
        }
    }*/

    func save(_ message: Message) {
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
        })
    }
}
