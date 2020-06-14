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

    private var docReference: DocumentReference?
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
                self.firebaseChat.loadChat(user2: self.secondUserId!, callback: { msg in
                    self.messages = msg
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
        let message = Message(userId: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUserId!, senderName: currentUserName!)

            //messages.append(message)
            insertNewMessage(message)
            firebaseChat.save(message)

            inputBar.inputTextView.text = ""
            messagesCollectionView.scrollToBottom()
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
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
