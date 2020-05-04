//
//  DetailsViewController.swift
//  PetRescue
//
//  Created by Flo on 05/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class DetailsViewController: NavBarSetUp {

    @IBOutlet weak var animalImages: UIImageView!
    @IBOutlet weak var animalMoreDetails: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalDetailsCell", for: indexPath)
        return cell
    }
}
