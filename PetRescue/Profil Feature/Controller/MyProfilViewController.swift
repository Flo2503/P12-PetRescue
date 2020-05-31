//
//  MyProfilViewController.swift
//  PetRescue
//
//  Created by Flo on 23/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyProfilViewController: UIViewController {

    private let userId = Auth.auth().currentUser?.uid
    private var unwindIdentifier = "unwindToLogin"
    private let cellTitle = ["Nom", "Prénom", "Adresse mail"]
    private var userInfo: [String] = []
    private var user: UserManager?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var editPasswordButton: UIButton!

    @IBAction func tapLogoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Vous êtes sur le point d'être déconnecté", message: "Continuer ?", preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "Oui", style: .default, handler: { _ in
            if UserManager.signOut() == true {
                self.performSegue(withIdentifier: self.unwindIdentifier, sender: self)
            } else {
                print("logout failure")
            }
        })
        let cancelAction = UIAlertAction(title: "Non", style: .cancel)
        alert.addAction(logout)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        ItemSetUp.buttonSetUp([editPasswordButton, logOutButton])
    }

    private func importDetails() {
        if let name  = user?.name, let firstName = user?.firstName, let email = user?.emailAddress {
            userInfo.append(name)
            userInfo.append(firstName)
            userInfo.append(email)
        }
    }
}

extension MyProfilViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTitle.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myProfilCell", for: indexPath) as? MyProfilTableViewCell else {
           return UITableViewCell()
        }
        cell.configureTitle(title: cellTitle[indexPath.row])
        if let currentUser = userId {
            UserManager.retrieveUser(userId: currentUser, callback: { currentUser in
                self.user = currentUser
                self.importDetails()
                //cell.configureDetails(details: self.userInfo[indexPath.row])
                self.tableView.reloadData()
            })
        }
        return cell
    }
}
