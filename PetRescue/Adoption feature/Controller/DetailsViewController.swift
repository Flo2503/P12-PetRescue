//
//  DetailsViewController.swift
//  PetRescue
//
//  Created by Flo on 05/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class DetailsViewController: NavBarSetUp {

    var selectedAd: AdManager?
    var adDetails: [String] = []
    let cellTitle = ["Nom", "Type/Race", "Genre", "Age", "Localité"]

    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var animalMoreDetails: UITextView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        display()
        importDetails()
        ItemSetUp.makeRounded(animalImage)
        self.tableView.tableFooterView = UIView()
    }

    private func importDetails() {
        if let name = selectedAd?.name, let kind = selectedAd?.kind, let gender = selectedAd?.gender, let age = selectedAd?.age, let locality = selectedAd?.locality {
            adDetails.append(name)
            adDetails.append(kind)
            adDetails.append(gender)
            adDetails.append(age)
            adDetails.append(locality)
        }
    }
}

extension DetailsViewController {
    private func display() {
        if let details = selectedAd?.details, let urlImage = selectedAd?.animalImage {
            animalMoreDetails.text = details
            AdManager.retrieveImage(url: urlImage, callback: { image in
                if let image = image {
                    self.animalImage.image = image
                }
            })
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        adDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        cell.detailTextLabel?.text = adDetails[indexPath.row]
        cell.textLabel?.text = cellTitle[indexPath.row]

        return cell
    }
}
