//
//  ProfilMenuViewController.swift
//  PetRescue
//
//  Created by Flo on 14/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ProfilMenuViewController: NavBarSetUp {

    let menuTitle = [Menu(title: "Mon profil"),
                     Menu(title: "Mes annonces")]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ProfilMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuTitle.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let menu = menuTitle[indexPath.row]
        cell.textLabel?.text = menu.title
        cell.imageView?.image = UIImage(named: menu.title)

        return cell
    }
}
