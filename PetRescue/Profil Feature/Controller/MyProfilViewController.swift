//
//  MyProfilViewController.swift
//  PetRescue
//
//  Created by Flo on 23/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import FirebaseAuth

enum ProfilSection: Int {
    case first
    case second
    case third
}

class MyProfilViewController: UIViewController {

    private let userId = Auth.auth().currentUser?.uid
    private var unwindIdentifier = "unwindToLogin"
    private let passwordSegue = "segueToChangePassword"
    private let cellTitle = ["Nom", "Prénom", "Adresse mail"]
    private let section = ["Mes informations", "Modifier mon mot de passe", "Déconnexion"]
    private var userInfo: [String] = []
    private var user: UserManager?

    @IBOutlet weak var tableView: UITableView!

    @IBAction func unwindToMyProfil(segue: UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ProfilSection(rawValue: section)! {
        case .first:
            return cellTitle.count
        case .second:
            return 1
        case .third:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myProfilCell", for: indexPath) as? MyProfilTableViewCell else {
           return UITableViewCell()
        }
        let passwordCell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell", for: indexPath)
        let logoutCell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)

        switch ProfilSection(rawValue: indexPath.section)! {
        case .first:
            cell.configureTitle(title: cellTitle[indexPath.row])
            if let currentUser = userId {
                UserManager.retrieveUser(userId: currentUser, callback: { currentUser in
                    self.user = currentUser
                    self.importDetails()
                    cell.configureDetails(details: self.userInfo[indexPath.row])
                    self.tableView.reloadData()
                })
            }
            return cell
        case .second:
            return passwordCell
        case .third:
            return logoutCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ProfilSection(rawValue: indexPath.section)! {
        case .first:
            print("Do nothing")
        case .second:
            performSegue(withIdentifier: passwordSegue, sender: self)
        case .third:
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
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Colors.customGreen
    }
}
