//
//  SignUpViewController.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var mailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordValidation: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    @IBAction func dismissKeyboard(_ sender: Any) {
        mailAdress.resignFirstResponder()
        password.resignFirstResponder()
        passwordValidation.resignFirstResponder()
    }

    @IBAction func didTapeValidate(_ sender: Any) {
        valideInput([passwordValidation, mailAdress, password])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        textFieldSetUp([mailAdress, password, passwordValidation])
        securePassword([password, passwordValidation])
        buttonsetUp()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
}

extension SignUpViewController {

    private func textFieldSetUp(_ textField: [UITextField]) {
        for item in textField {
            item.layer.borderWidth = 3
            item.layer.borderColor = Colors.customGreen.cgColor
            item.layer.cornerRadius = 25
            item.borderStyle = .none
        }
    }

    private func securePassword(_ textField: [UITextField]) {
        for item in textField {
            item.isSecureTextEntry = true
        }
    }

    private func valideInput(_ textField: [UITextField]) {
        for item in textField {
            guard !item.text!.isEmpty else {
                return
            }
        }
    }

    private func buttonsetUp() {
        validateButton.layer.cornerRadius = 25
        validateButton.layer.borderWidth = 3
        validateButton.layer.borderColor = UIColor.white.cgColor
        validateButton.layer.backgroundColor = Colors.customGreen.cgColor
    }
}
