//
//  TabBarSetUpController.swift
//  PetRescue
//
//  Created by Flo on 06/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class TabBarSetUpController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBar.tintColor = Colors.customGreen
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}
