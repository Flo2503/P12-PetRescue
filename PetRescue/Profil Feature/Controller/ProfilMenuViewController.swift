//
//  ProfilMenuViewController.swift
//  PetRescue
//
//  Created by Flo on 14/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ProfilMenuViewController: NavBarSetUp {

    // MARK: - Property
    private let menuTitle = [Menu(title: "Mon profil"), Menu(title: "Mes annonces")]

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
}

// MARK: - Extension
// Table view extension
extension ProfilMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuTitle.count
    }
    ///Access to my profil ans my ads
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "segueToMyProfil", sender: self)
        case 1:
            performSegue(withIdentifier: "segueToMyAd", sender: self)
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let menu = menuTitle[indexPath.row]
        cell.textLabel?.text = menu.title

        return cell
    }
}
