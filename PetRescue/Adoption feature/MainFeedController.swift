//
//  AlertAndAdoptionController.swift
//  PetRescue
//
//  Created by Flo on 01/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class MainFeedController: NavBarSetUp {

    private var identifier = "segueToDetails"
    private var unwindIdentifier = "unwindToLogin"

    @IBAction func unwindToMainFeed(segue: UIStoryboardSegue) { }

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
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}

extension MainFeedController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainFeedCell", for: indexPath) as? MainFeedTableViewCell else {
        return UITableViewCell()
        }
        return cell
    }
}
