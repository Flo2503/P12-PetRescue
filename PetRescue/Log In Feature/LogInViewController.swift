//
//  LogInViewController.swift
//  PetRescue
//
//  Created by Flo on 24/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var inscriptionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius([connexionButton, inscriptionButton])
    }

    private func cornerRadius(_ buttons: [UIButton]) {
        for element in buttons {
            element.layer.cornerRadius = 22
            element.layer.borderWidth = 3
            element.layer.borderColor = UIColor.white.cgColor
        }
    }
}
