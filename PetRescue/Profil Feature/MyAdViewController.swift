//
//  MyAdViewController.swift
//  PetRescue
//
//  Created by Flo on 17/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyAdViewController: NavBarSetUp {

    private let user = Auth.auth().currentUser!.uid.description
    private var ads: [AdManager] = []

    @IBOutlet weak var myAdTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        print(ads.description)
    }

    private func retrieveData() {
        let ref = Database.database().reference(withPath: "ads")
        let query = ref.queryOrdered(byChild: user).queryEqual(toValue: true)
        query.observe(.value, with: { snapshot in
        var newAd: [AdManager] = []
        for child in snapshot.children {
            if let snapshot = child as? DataSnapshot,
                let animalAd = AdManager(snapshot: snapshot) {
                newAd.append(animalAd)
            }
          }
          self.ads = newAd
          self.myAdTableView.reloadData()
        })
    }
}
