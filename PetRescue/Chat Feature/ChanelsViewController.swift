//
//  ChanelsViewController.swift
//  PetRescue
//
//  Created by Flo on 10/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ChanelsViewController: NavBarSetUp {

    private var currentUserId = UserManager.currentConnectedUser

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
}
