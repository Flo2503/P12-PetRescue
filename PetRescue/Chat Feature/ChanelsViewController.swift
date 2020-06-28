//
//  ChanelsViewController.swift
//  PetRescue
//
//  Created by Flo on 10/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ChanelsViewController: NavBarSetUp {

    // MARK: - Properties, instances
    private let identifier = "segueToChatViewController"
    private var currentUserId = UserManager.currentUserId
    private let userManager = UserManager()
    private let chatManager = ChatManager()
    private var chatUsersDetails: [User] = []
    var secondUserId: String?

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.tableFooterView = UIView()
        self.chatUsersDetails = []
        chatManager.getChatUsers(callback: { chat in
            guard let chat = chat else { return }
            self.getUsersInformation(chats: chat)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        if NetworkManager.connection() == false {
            NetworkManager.alert(controller: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == identifier {
               let detailsVC = segue.destination as! ChatViewController
               detailsVC.secondUserId = secondUserId
           }
       }

    /// Retrieve users informations. Callback returns an user and append it in chatUserDetails
    private func getUsersInformation(chats: [Chat]) {
        for chat in chats {
            for userId in chat.users where userId != currentUserId {
                userManager.retrieveChatUser(userChatId: userId, callback: { user in
                    self.chatUsersDetails.append(user)
                    self.tableView.reloadData()
                })
            }
        }
    }
}

// MARK: - Extension
// Table view extension
extension ChanelsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let chatUserDetails = chatUsersDetails
        return chatUserDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chanelCell", for: indexPath)
        let user = self.chatUsersDetails[indexPath.row]
        cell.textLabel?.text = user.firstName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secondUserId = chatUsersDetails[indexPath.row].userId
        self.performSegue(withIdentifier: identifier, sender: self)
    }

}
