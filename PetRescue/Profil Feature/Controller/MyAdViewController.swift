//
//  MyAdViewController.swift
//  PetRescue
//
//  Created by Flo on 17/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class MyAdViewController: NavBarSetUp {
    // MARK: - Properties, instances
    private var identifier = "segueFromMyAdToDetails"
    private let userId = UserManager.currentUserId
    private let adManager = AdManager()
    private var ads: [Ad] = []
    var selectedAd: Ad?

    // MARK: - Outlet
    @IBOutlet weak var myAdTableView: UITableView!

    // MARK: - Methods
    ///Call "getMyAds" retreiving ads with userId filter
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myAdTableView.tableFooterView = UIView()
        guard let userId = userId else { return }
        adManager.getMyAds(userId: userId, callback: { ads in
            self.ads = ads
            self.myAdTableView.reloadData()
            print(ads.description)
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        if NetworkManager.connection() == false {
            NetworkManager.alert(controller: self)
        }
    }

    ///Prepare for segue giving the object of the selected ad to DetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.selectedAd = selectedAd
        }
    }

    ///Remove object in ads array
    private func removeAd(at index: Int) {
        ads.remove(at: index)
    }
}

// MARK: - Extension
// Table view extension
extension MyAdViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ads.count
    }
    ///Call "retrieveImage" allowing tu download animal image and display it in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myAdCell", for: indexPath) as? MyAdTableViewCell else {
            return UITableViewCell()
        }
        let animal = ads[indexPath.row]
        cell.configure(name: animal.name, locality: animal.locality)
        adManager.retrieveImage(url: animal.animalImage, callback: { image in
            if let image = image {
                cell.configureImage(image: image)
            }
        })
        return cell
    }
    ///Allow to delete ads in array calling  "removeAd" and delete ads on realtime database callling "AdManager.removeAd". Allow to delete animal image in Firebase storage calling "AdManager.removePicture"
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let animal = ads[indexPath.row]
        if editingStyle == .delete {
            removeAd(at: indexPath.row)
            adManager.removeAd(withId: animal.key)
            adManager.removePicture(url: animal.animalImage)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAd = ads[indexPath.row]
        self.performSegue(withIdentifier: identifier, sender: self)
    }

}
