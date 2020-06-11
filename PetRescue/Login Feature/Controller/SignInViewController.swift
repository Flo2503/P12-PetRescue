//
//  SignInViewController.swift
//  PetRescue
//
//  Created by Flo on 29/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: NavBarSetUp {

    private let identifier = "segueToAdoptions"
    private let erroMessage = "Adresse mail ou mot de passe incorrect"

    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdress.resignFirstResponder()
        password.resignFirstResponder()
    }

    @IBAction func tapOnValidate(_ sender: Any) {
        let isEmailAddressValid = InputValuesManager.isValidEmailAddress(emailAddressString: emailAdress.text!)
        if isEmailAddressValid && fieldIsNotEmpty([password, emailAdress]) {
            login()
        } else {
            validateButton.layer.backgroundColor = UIColor.red.cgColor
            signInLabel.text = erroMessage
        }
    }

    @IBAction func unwindToSignIn(segue: UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()
        securePassword()
        ItemSetUp.buttonSetUp([validateButton])
        ItemSetUp.textFieldSetUp([emailAdress, password])
        emailAdress.text = "test@test.fr"
        password.text = "Test1234"
    }

    private func login() {
        if let email = emailAdress.text?.trimmingCharacters(in: .whitespaces), let password = password.text?.trimmingCharacters(in: .whitespaces) {
            self.validateButton.isEnabled = false
            self.validateButton.layer.backgroundColor = Colors.customGreenLight.cgColor
            UserManager.login(withEmail: email, password: password, callback: { success in
                if success {
                    self.performSegue(withIdentifier: self.identifier, sender: self)
                    self.validateButton.layer.backgroundColor = Colors.customGreen.cgColor
                } else {
                    self.validateButton.isEnabled = true
                    self.validateButton.layer.backgroundColor = UIColor.red.cgColor
                    self.signInLabel.text = self.erroMessage
                }
            })
        }
    }

    private func securePassword() {
        password.isSecureTextEntry = true
    }

    private func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }
}
