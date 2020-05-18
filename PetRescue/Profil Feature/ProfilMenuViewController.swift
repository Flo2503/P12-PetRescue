//
//  ProfilMenuViewController.swift
//  PetRescue
//
//  Created by Flo on 14/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ProfilMenuViewController: NavBarSetUp {

    @IBOutlet weak var tableView: UITableView!

    private let menuTitle = [Menu(title: "Mon profil"), Menu(title: "Mes annonces")]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
}

extension ProfilMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuTitle.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "segueToMyProfil", sender: self)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "segueToMyAd", sender: self)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let menu = menuTitle[indexPath.row]
        cell.textLabel?.text = menu.title

        return cell
    }
}
