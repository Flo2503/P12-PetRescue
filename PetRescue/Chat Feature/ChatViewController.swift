//
//  ChatViewController.swift
//  PetRescue
//
//  Created by Flo on 09/06/2020.
//  Copyright © 2020 Flo. All rights reserved.

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    private var secondUser: UserManager?
    private var currentUser: UserManager?
    var selectedAd: AdManager?

    var currentUserName: String?
    var currentUserUrl: String?
    var currentUserId = Auth.auth().currentUser?.uid

    var secondUserName: String?
    var secondUserUrl: String?
    var secondUserId: String?

    private var docReference: DocumentReference?

    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = secondUserName ?? ""
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = Colors.customGreen
        messageInputBar.sendButton.setTitleColor(Colors.customGreen, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        noShadow()
    }

    override func viewWillAppear(_ animated: Bool) {
        getCurrentUser()
        getSecondUser()
    }

    // MARK: - Custom messages handlers
    func createNewChat() {
        let users = [self.currentUserId, self.secondUserId]
         let data: [String: Any] = ["users": users]
         let database = Firestore.firestore().collection("Chats")
         database.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                 self.loadChat()
             }
         }
    }

    func loadChat() {
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
                        if (chat?.users.contains(self.secondUserId!))! {
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
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToBottom(animated: true)
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
    }

    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    private func save(_ message: Message) {
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.userId,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            self.messagesCollectionView.scrollToBottom()
        })
    }

    private func currentUserInfo() {
        if let firstName = currentUser?.firstName, let userPicture = currentUser?
            .userPicture {
            self.secondUserName = firstName
            self.secondUserUrl = userPicture
        }

    }

    private func secondUserInfo() {
        if let firstName = secondUser?.firstName, let userPicture = secondUser?
            .userPicture, let userId = selectedAd?.userId {
            self.secondUserName = firstName
            self.secondUserUrl = userPicture
            self.secondUserId = userId
        }
    }

    private func getCurrentUser() {
        UserManager.retrieveUser(callback: { user in
            self.currentUser = user
            self.currentUserInfo()
        })
    }

    private func getSecondUser() {
        if let secondUser = selectedAd?.userId {
            UserManager.retrieveChatUser(userChatId: secondUser, callback: { chatUser in
                self.secondUser = chatUser
                self.secondUserInfo()
            })
        }
    }

    private func noShadow() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK: - InputBarAccessoryViewDelegate
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let currentUser = currentUserId {
            let message = Message(userId: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser, senderName: "")

            //messages.append(message)
            insertNewMessage(message)
            save(message)

            inputBar.inputTextView.text = ""
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        return Sender(senderId: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messages.count
        }
    }

    // MARK: - MessagesLayoutDelegate
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? Colors.customGreen: .lightGray
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}
