//
//  DetailsViewController.swift
//  PetRescue
//
//  Created by Flo on 05/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

enum Section: Int {
    case first
    case second
}

class DetailsViewController: NavBarSetUp {
    // MARK: - Properties, instances
    private let identifier = "segueToChat"
    private let cellTitle = ["Nom", "Type/Race", "Genre", "Age", "Localité"]
    private let section =  ["Profil du compagnon", "Informations complémentaires"]
    private var adDetails: [String] = []
    private let currentUser = UserManager.currentConnectedUser
    private let chat = ChatManager()
    private let adManager = AdManager()
    var selectedAd: Ad?

    // MARK: - Oulets
    @IBOutlet weak var animalImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        display()
        importDetails()
        ItemSetUp.makeRounded(animalImage)
        self.tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        if isMyAd() == true {
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            let detailsVC = segue.destination as! ChatViewController
            detailsVC.selectedAd = selectedAd
        }
    }

    ///Import ad details in array
    private func importDetails() {
        if let name = selectedAd?.name, let kind = selectedAd?.kind, let gender = selectedAd?.gender, let age = selectedAd?.age, let locality = selectedAd?.locality {
            adDetails.append(name)
            adDetails.append(kind)
            adDetails.append(gender)
            adDetails.append(age)
            adDetails.append(locality)
        }
    }

    private func isMyAd() -> Bool {
        return selectedAd?.userId == currentUser
    }
}

// MARK: - Extensions
extension DetailsViewController {

    ///Retreive animal Image calling "retreiveImage" and display it in image view
    private func display() {
        if let urlImage = selectedAd?.animalImage {
             adManager.retrieveImage(url: urlImage, callback: { image in
                if let image = image {
                    self.animalImage.image = image
                }
            })
        }
    }
}

// Table View
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .first:
            return adDetails.count
        case .second:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        guard let furtherDetailsCell = tableView.dequeueReusableCell(withIdentifier: "furtherDetailsCell", for: indexPath) as? FurtherDetailsTableViewCell else {
            return UITableViewCell()
        }
        switch Section(rawValue: indexPath.section)! {
        case .first:
            cell.detailTextLabel?.text = adDetails[indexPath.row]
            cell.textLabel?.text = cellTitle[indexPath.row]
            return cell
        case .second:
            if let furtherDetails = selectedAd?.details {
                furtherDetailsCell.configure(details: furtherDetails)
            }
            return furtherDetailsCell
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Colors.customGreen
    }
}
