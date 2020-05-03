//
//  AlertAndAdoptionController.swift
//  PetRescue
//
//  Created by Flo on 01/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class MainFeedController: NavBarSetUp {

    @IBAction func unwindToMainFeed(segue: UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
}

extension MainFeedController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainFeedCell", for: indexPath) as? MainFeedTableViewCell else {
        return UITableViewCell()
        }
        return cell
    }
}
