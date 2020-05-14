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

    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var animalMoreDetails: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        display()
        importDetails()
    }

    private func importDetails() {
        if let kind = selectedAd?.kind, let gender = selectedAd?.gender, let age = selectedAd?.age, let locality = selectedAd?.locality {
            adDetails.append("Type / Race: \(kind)")
            adDetails.append("Genre: \(gender)")
            adDetails.append("Age: \(age)")
            adDetails.append("Localité: \(locality)")
        }
    }
}

extension DetailsViewController {
    private func display() {
        if let details = selectedAd?.details, let urlImage = selectedAd?.animalImage, let name = selectedAd?.name {
            animalName.text = name
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
        cell.textLabel?.text = adDetails[indexPath.row]

        return cell
    }
}
