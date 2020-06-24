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

    // MARK: - Properties, instances
    private var identifier = "segueToDetails"
    private var unwindIdentifier = "unwindToLogin"
    private let ref = Database.database().reference(withPath: "ads")
    private let adManager = AdManager()
    private var ads: [Ad] = []
    var selectedAd: Ad?

    // MARK: - Refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(MainFeedController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()

    // MARK: - Outlets
    @IBOutlet weak var adTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Actions
    @IBAction func unwindToMainFeed(segue: UIStoryboardSegue) {
        adTableView?.reloadData()
    }

    // MARK: - Methods
    ///Call "retrieveData" method. Retrieve all ads and store them in ads array
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        adManager.retrieveData(callback: { newAd in
            self.activityIndicator.isHidden = true
            self.ads = newAd
            self.adTableView.reloadData()
        })
        self.adTableView.addSubview(self.refreshControl)
    }

    ///Prepare for segue allowing to give the object of the selected ad to DetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.selectedAd = selectedAd
        }
    }

    ///Handle refresh. Call "forceRetrieveData" allowing tu update ads in ''ads array" and display them
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        adManager.forceRetrieveData(callback: { newAd in
            self.ads = newAd
            self.adTableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
}

// MARK: - Extension
///TableView extension. Display ads stored in ads array. Call "retrieveImage" alllowing to download animal image and display it in cell
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

        adManager.retrieveImage(url: animal.animalImage, callback: { image in
            if let image = image {
                cell.configureImage(image: image)
            }
        })

        cell.configure(name: animal.name, kind: animal.kind, locality: animal.locality)

        return cell
    }
}
