//
//  ChanelsViewController.swift
//  PetRescue
//
//  Created by Flo on 10/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ChanelsViewController: NavBarSetUp {

    private let identifier = "segueToChatViewController"
    private var currentUserId = UserManager.currentConnectedUser
    private let userManager = UserManager()
    private let chatManager = ChatManager()
    private var chatUserDetails: [User]?
    private var messages: [Message] = []
    private var chats: [Chat] = []
    private var allUsersId: [String] = []
    private var contactId: [String] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.tableFooterView = UIView()
        chatManager.getChat(callback: { chat in
            guard let chat = chat else { return }
            self.chats = chat
            self.getAllUsersId()
            self.getContactUserId()
            self.getUsersInformation()
            self.tableView.reloadData()
            print(self.contactId)
        })
    }

    private func getAllUsersId() {
        for users in chats {
            allUsersId.append(contentsOf: users.users)
        }
    }

    private func getContactUserId() {
        for (index, element) in allUsersId.enumerated() where index % 2 == 1 {
            contactId.append(element)
        }
    }

    private func getUsersInformation() {
        userManager.retrieveAllChatUser(userChatId: contactId, callback: { users in
            self.chatUserDetails = users
        })
    }
}

// MARK: - Extension
// Table view extension
extension ChanelsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let chatUserDetails = chatUserDetails else {
            return 0
        }
        return chatUserDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chanelCell", for: indexPath)
        guard let chatUserDetails = chatUserDetails else {
            return UITableViewCell()
        }
        let user = chatUserDetails[indexPath.row]
        cell.textLabel?.text = user.firstName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }

}
