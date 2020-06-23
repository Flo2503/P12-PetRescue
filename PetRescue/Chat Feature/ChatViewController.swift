//
//  ChatViewController.swift
//  PetRescue
//
//  Created by Flo on 09/06/2020.
//  Copyright © 2020 Flo. All rights reserved.

import UIKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import MessageKit

public struct Sender: SenderType {
    public let senderId: String

    public let displayName: String
}

class ChatViewController: MessagesViewController {

    // MARK: - Properties, instances
    private var secondUser: User?
    private var currentUser: User?
    private var messages: [Message] = []
    private let currentUserId = UserManager.currentUserId
    private let chatManager = ChatManager()
    private let userManager = UserManager()
    var secondUserId: String?

    // MARK: - Methods
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
        IQKeyboardManager.shared.enable = false
        noShadow()
        getChat()
    }

    override func viewWillAppear(_ animated: Bool) {
        getUsers()
    }

    ///Call loadChat to get users conversation
    private func getChat() {
        if let userId = secondUserId {
            self.chatManager.loadChat(user2: userId, callback: { msg in
                self.messages = msg
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
            })
        }
    }

    /// Insert new message in messages array then display it
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }

    /// Get users informations
    private func getUsers() {
        userManager.retrieveUser(callback: { user in
            self.currentUser = user
        })
        if let userId = secondUserId {
            userManager.retrieveChatUser(userChatId: userId, callback: { chatUser in
                self.secondUser = chatUser
                if let firstName = self.secondUser?.firstName {
                    self.title = firstName
                }
            })
        }
    }

    private func noShadow() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

// MARK: - Extension MessagesDataSource
extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        return Sender(senderId: currentUserId!, displayName: currentUser?.firstName ?? "Name")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}

// MARK: - Extension MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {

    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
}

// MARK: - Extension MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? Colors.currentUserMessageColor : Colors.secondUserMessageColor
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == currentUserId {
            avatarView.image = UIImage(named: "current_user")
            avatarView.layer.backgroundColor = UIColor.white.cgColor
            avatarView.layer.borderWidth = 0
        } else {
            avatarView.image = UIImage(named: "second_user")
            avatarView.layer.backgroundColor = UIColor.white.cgColor
            avatarView.layer.borderWidth = 0
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

// MARK: - Extension InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let currentUserId = currentUserId, let currentUserFirstName = currentUser?.firstName {
            let message = Message(id: UUID().uuidString,
                                  content: text,
                                  created: chatManager.timeStamp,
                                  senderID: currentUserId,
                                  senderName: currentUserFirstName)
            messages.append(message)
            insertNewMessage(message)
            chatManager.save(message)
            inputBar.inputTextView.text = ""
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToBottom(animated: true)
        }
    }
}
