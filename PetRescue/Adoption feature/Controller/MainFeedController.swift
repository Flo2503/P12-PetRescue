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
    var selectedAd: AdManager?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(MainFeedController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Colors.customGreen
        return refreshControl
    }()

    @IBOutlet weak var adTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func unwindToMainFeed(segue: UIStoryboardSegue) {
        adTableView?.reloadData()
    }

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
        AdManager.retrieveData(callback: { newAd in
            self.activityIndicator.isHidden = true
            self.ads = newAd
            self.adTableView.reloadData()
        })
        self.adTableView.addSubview(self.refreshControl)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.selectedAd = selectedAd
        }
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        AdManager.forceRetrieveData(callback: { newAd in
            self.ads = newAd
            self.adTableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
}

extension MainFeedController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAd = ads[indexPath.row]
        self.performSegue(withIdentifier: identifier, sender: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainFeedCell", for: indexPath) as? MainFeedTableViewCell else {
        return UITableViewCell()
        }
        let animal = ads[indexPath.row]

        AdManager.retrieveImage(url: animal.animalImage, callback: { image in
            if let image = image {
                cell.configureImage(image: image)
            }
        })

        cell.configure(name: animal.name, kind: animal.kind, locality: animal.locality)

        return cell
    }
}
