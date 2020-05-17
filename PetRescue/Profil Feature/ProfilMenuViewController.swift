//
//  ProfilMenuViewController.swift
//  PetRescue
//
//  Created by Flo on 14/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ProfilMenuViewController: NavBarSetUp {

    private let menuTitle = [Menu(title: "Mon profil", identifier: "segueToMyProfil"), Menu(title: "Mes annonces", identifier: "segueToMyAd")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ProfilMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuTitle.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let menu = menuTitle[indexPath.row]
        cell.textLabel?.text = menu.title
        cell.imageView?.image = UIImage(named: menu.title)

        return cell
    }
}
