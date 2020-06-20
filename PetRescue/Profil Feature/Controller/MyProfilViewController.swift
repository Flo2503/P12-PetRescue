//
//  MyProfilViewController.swift
//  PetRescue
//
//  Created by Flo on 23/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

enum ProfilSection: Int {
    case first
    case second
    case third
    case fourth
}

class MyProfilViewController: UIViewController {

    // MARK: - Properties, instances
    private var unwindIdentifier = "unwindToLogin"
    private let passwordSegue = "segueToChangePassword"
    private let editEmailSegue = "segueToEditEmail"
    private let cellTitle = ["Nom", "Prénom", "Adresse mail"]
    private let section = ["Mes informations", "Modifier mon mot de passe", "Modifier mon adresse mail", "Déconnexion"]
    private var userInfo: [String] = []
    private var user: User?
    private let userManager = UserManager()

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Actions
    @IBAction func unwindToMyProfil(segue: UIStoryboardSegue) { }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }

    private func importDetails() {
        if let name = user?.name, let firstName = user?.firstName, let email = user?.emailAddress {
            userInfo.append(name)
            userInfo.append(firstName)
            userInfo.append(email)
        }
    }
}

// MARK: - Extension
///Table View extension
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
        case .fourth:
            return 1
        }
    }
    ///Call "retrieveUser" allowing retrieve user's informations
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProfilCell", for: indexPath)
        let passwordCell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell", for: indexPath)
        let editEmailCell = tableView.dequeueReusableCell(withIdentifier: "editEmailCell", for: indexPath)
        let logoutCell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)

        switch ProfilSection(rawValue: indexPath.section)! {
        case .first:
            cell.textLabel?.text = cellTitle[indexPath.row]
            userManager.retrieveUser(callback: { currentUser in
                self.user = currentUser
                self.importDetails()
                cell.detailTextLabel?.text = self.userInfo[indexPath.row]
            })
            return cell
        case .second:
            return passwordCell
        case .third:
            return editEmailCell
        case .fourth:
            return logoutCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ProfilSection(rawValue: indexPath.section)! {
        case .first:
            print("Do nothing")
        case .second:
            // Change Password
            performSegue(withIdentifier: passwordSegue, sender: self)
        case .third:
            // Edit email address
            performSegue(withIdentifier: editEmailSegue, sender: self)
        case .fourth:
            // Logout
            let alert = UIAlertController(title: "Vous êtes sur le point d'être déconnecté", message: "Continuer ?", preferredStyle: .actionSheet)
            let logout = UIAlertAction(title: "Oui", style: .default, handler: { _ in
                if self.userManager.signOut() == true {
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
        header.textLabel?.textColor = UIColor.white
    }
}
