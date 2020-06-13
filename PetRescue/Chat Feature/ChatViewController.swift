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

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    private var secondUser: UserManager?
    private var currentUser: UserManager?
    private var currentUserName: String?
    private let currentUserId = UserManager.currentConnectedUser
    private var secondUserName: String?
    private var secondUserId: String?
    private let firebaseChat = FirebaseChat()
    private var messages: [Message] = []
    var selectedAd: AdManager?

    override func viewDidLoad() {
        super.viewDidLoad()
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
    private func createNewChat() {
         let users = [currentUserId, secondUserId]
         let data: [String: Any] = ["users": users]
         let database = Firestore.firestore().collection("Chats")
         database.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                print("ok")
             }
         }
    }

    /*private func loadChat() {
        //Fetch all the chats which has current user in it
        let database = Firestore.firestore().collection("Chats")
                .whereField("users", arrayContains: currentUserId ?? "Not Found User 1")
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
                                    if let msg = Message(dictionary: message.data()) {
                                        self.messages.append(msg)
                                        print("Data: \(msg.content)")
                                    }
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

    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    private func currentUserInfo() {
        if let firstName = currentUser?.firstName {
            self.currentUserName = firstName
        }

    }

    private func secondUserInfo() {
        if let firstName = secondUser?.firstName, let userId = selectedAd?.userId {
            self.secondUserName = firstName
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
                self.title = self.secondUserName
                self.firebaseChat.loadChat(user2: self.secondUserId!, callback: { messages in
                    self.messages = messages
                })
            })
        }
    }

    private func noShadow() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK: - InputBarAccessoryViewDelegate
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let currentUser = currentUserId, let userName = currentUserName {
            let message = Message(userId: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser, senderName: userName)

            //messages.append(message)
            insertNewMessage(message)
            firebaseChat.save(message)

            inputBar.inputTextView.text = ""
            messagesCollectionView.scrollToBottom()
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        return Sender(senderId: currentUserId!, displayName: currentUserName ?? "Name not found")
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

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.image = UIImage(named: "default_user")
        avatarView.layer.backgroundColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = Colors.avatarViewBorder.cgColor
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}
