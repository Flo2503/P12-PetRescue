//
//  SignUpDetailsViewController.swift
//  PetRescue
//
//  Created by Flo on 27/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class SignUpDetailsViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var association: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var town: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSetUp([name, firstName, association, adress, town, postalCode])
        buttonsetUp()
    }
}

extension SignUpDetailsViewController {

    private func textFieldSetUp(_ textField: [UITextField]) {
        for item in textField {
            item.layer.borderWidth = 3
            item.layer.borderColor = Colors.customGreen.cgColor
            item.layer.cornerRadius = 25
            item.borderStyle = .none
        }
    }

    private func buttonsetUp() {
        validateButton.layer.cornerRadius = 25
        validateButton.layer.borderWidth = 3
        validateButton.layer.borderColor = UIColor.white.cgColor
        validateButton.layer.backgroundColor = Colors.customGreen.cgColor
    }

    private func valideInput(_ textField: [UITextField]) {
        for item in textField {
            guard !item.text!.isEmpty else {
                return
            }
        }
    }

}
