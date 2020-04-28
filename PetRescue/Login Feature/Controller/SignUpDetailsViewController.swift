//
//  SignUpDetailsViewController.swift
//  PetRescue
//
//  Created by Flo on 27/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class SignUpDetailsViewController: NavBarSetUp {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var association: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var town: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        DisplaySetUp.textFieldSetUp([name, firstName, association, adress, town, postalCode])
        DisplaySetUp.buttonsetUp(validateButton)
    }
}
