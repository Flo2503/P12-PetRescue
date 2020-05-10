//
//  AlertAndAdoptionController.swift
//  PetRescue
//
//  Created by Flo on 01/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainFeedController: NavBarSetUp {

    private var identifier = "segueToDetails"
    private var unwindIdentifier = "unwindToLogin"
    private let ref = Database.database().reference(withPath: "ads")
    private var ads: [AdManager] = []

    @IBOutlet weak var adTableView: UITableView!

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
        retrieveData()
    }

    private func retrieveData() {
        ref.observe(.value, with: { snapshot in
          var newAd: [AdManager] = []
          for child in snapshot.children {
            if let snapshot = child as? DataSnapshot,
               let animalAd = AdManager(snapshot: snapshot) {
              newAd.append(animalAd)
            }
          }
          self.ads = newAd
          self.adTableView.reloadData()
        })
    }
}

extension MainFeedController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainFeedCell", for: indexPath) as? MainFeedTableViewCell else {
        return UITableViewCell()
        }
        let animal = ads[indexPath.row]

        cell.configure(name: animal.name, kind: animal.kind, locality: animal.locality)

        return cell
    }
}
