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
    private let userId = UserManager.currentConnectedUser
    private var ads: [AdManager] = []
    private var identifier = "segueFromMyAdToDetails"
    var selectedAd: AdManager?
    // MARK: - Outlet
    @IBOutlet weak var myAdTableView: UITableView!
    // MARK: - Methods
    ///Call "getMyAds" retreiving ads with userId filter
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myAdTableView.tableFooterView = UIView()
        guard let userId = userId else { return }
        AdManager.getMyAds(userId: userId, callback: { ads in
            self.ads = ads
        })
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
        AdManager.retrieveImage(url: animal.animalImage, callback: { image in
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
            AdManager.removeAd(withId: animal.key)
            AdManager.removePicture(url: animal.animalImage)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAd = ads[indexPath.row]
        self.performSegue(withIdentifier: identifier, sender: self)
    }

}
