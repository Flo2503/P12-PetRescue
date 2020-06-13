//
//  ChanelsViewController.swift
//  PetRescue
//
//  Created by Flo on 10/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChanelsViewController: NavBarSetUp {

    private var currentUserId = Auth.auth().currentUser?.uid

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
}
