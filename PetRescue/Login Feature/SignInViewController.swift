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

    // MARK: - Properties, instance
    private let identifier = "segueToAdoptions"
    private let erroMessage = "Adresse mail ou mot de passe incorrect"
    private let userManager = UserManager()

    // MARK: - Outlets
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    // MARK: - Actions
    /// Dismiss Keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdress.resignFirstResponder()
        password.resignFirstResponder()
    }

    ///Check email is valid, fields are not empty, then call "login" method
    @IBAction func tapOnValidate(_ sender: Any) {
        let isEmailAddressValid = InputValuesManager.isValidEmailAddress(emailAddressString: emailAdress.text!)
        let deviceIsOnline = NetworkManager.connection() == true
        if isEmailAddressValid && fieldIsNotEmpty([password, emailAdress]) && deviceIsOnline {
            login()
        } else {
            validateButton.layer.backgroundColor = UIColor.red.cgColor
            signInLabel.text = erroMessage
        }
    }

    // Unwind Segue
    @IBAction func unwindToSignIn(segue: UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()
        securePassword()
        ItemSetUp.buttonSetUp([validateButton])
        ItemSetUp.textFieldSetUp([emailAdress, password])
    }

    override func viewDidAppear(_ animated: Bool) {
        if NetworkManager.connection() == false {
            NetworkManager.alert(controller: self)
            validateButton.layer.backgroundColor = Colors.customLightGreen.cgColor
            validateButton.isEnabled = false
        }
    }

    ///Call "login" method in UserManager allow to login user on database with email and password
    private func login() {
        if let email = emailAdress.text?.trimmingCharacters(in: .whitespaces), let password = password.text?.trimmingCharacters(in: .whitespaces) {
            self.validateButton.isEnabled = false
            self.validateButton.layer.backgroundColor = Colors.customLightGreen.cgColor
            userManager.login(withEmail: email, password: password, callback: { success in
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
}

// MARK: - Extension
/// Extension input Values
extension SignInViewController {

    ///Hide input user value
    private func securePassword() {
        password.isSecureTextEntry = true
    }

    ///Check text fields are noy empty
    private func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }
}
