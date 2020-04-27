//
//  NoNavBarShadowViewController.swift
//  PetRescue
//
//  Created by Flo on 27/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class NavBarSetUp: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        noShadow()
    }

    func noShadow() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
