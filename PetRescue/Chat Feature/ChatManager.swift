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
        chatDatabase.addDocument(data: data) { (error) in
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
        let database = chatDatabase.whereField("users", arrayContains: currentUserId!)
        database.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                if queryCount >= 1 {
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        if (chat?.users.contains(user2))! {
                            self.docReference = doc.reference
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
                                    if let storedMessage = Message(dictionary: message.data()) {
                                        retreiveMessages.append(storedMessage)
                                        print("Data: \(storedMessage.content)")
                                    }
                                }
                                callback(retreiveMessages)
                            }
                            })
                            return
                        }
                    }
                    self.createNewChat(user2: user2)
                }
            }
        }
    }

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

    func getChat(callback: @escaping (_ currentUserDocuments: [Chat]?) -> Void) {
        guard let userId = currentUserId else { return }
        let database = chatDatabase.whereField("users", arrayContains: userId)
        database.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else { return }
                if queryCount >= 1 {
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        var chatDocuments = [Chat]()
                        if let chat = chat {
                            chatDocuments.append(chat)
                        }
                        callback(chatDocuments)
                    }
                }
            }
        }
    }
}
