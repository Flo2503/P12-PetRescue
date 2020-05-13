//
//  SignUpViewController.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.

import UIKit

class SignUpViewController: NavBarSetUp {

    private let identifier = "segueToAdoptions"
    private let errorMessage = "Informations incorrectes"

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordValidation: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var labelSignUp: UILabel!

    @IBAction func dismissKeyboard(_ sender: Any) {
        emailAdress.resignFirstResponder()
        password.resignFirstResponder()
        passwordValidation.resignFirstResponder()
    }

    @IBAction func tapOnValidate(_ sender: Any) {

        let isEmailAddressValid = InputValuesManager.isValidEmailAddress(emailAddressString: emailAdress.text!)
        let passwordsAreEquals = InputValuesManager.passwordsAreEquals(passwordOne: password.text, passwordTwo: passwordValidation.text)
        let fieldIsNotEmpty = InputValuesManager.fieldIsNotEmpty([passwordValidation, password, emailAdress, name, firstName])
        let isValidPassword = InputValuesManager.isValidPassword(password: password.text)
        let isValidSecondPassword = InputValuesManager.isValidPassword(password: passwordValidation.text)

        if isEmailAddressValid &&
            passwordsAreEquals &&
            fieldIsNotEmpty &&
            isValidPassword &&
            isValidSecondPassword {
            signUp()
        } else {
            labelSignUp.text = errorMessage
            validateButton.layer.backgroundColor = UIColor.red.cgColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        InputValuesManager.securePassword([password, passwordValidation])
        ItemSetUp.buttonsetUp(validateButton)
        ItemSetUp.textFieldSetUp([emailAdress, password, passwordValidation, name, firstName
        ])
    }

    private func signUp() {
        if let email = emailAdress.text, let password = password.text, let name = name.text, let firstName = firstName.text {
            self.validateButton.isEnabled = false
            self.validateButton.layer.backgroundColor = Colors.customGreenLight.cgColor
            UserManager.createUser(email: email, password: password, name: name, firstName: firstName, callback: {success in
                if success {
                    self.validateButton.layer.backgroundColor = Colors.customGreen.cgColor
                    self.performSegue(withIdentifier: self.identifier, sender: self)
                } else {
                    self.labelSignUp.text = self.errorMessage
                    self.validateButton.isEnabled = true
                    self.validateButton.layer.backgroundColor = UIColor.red.cgColor
                }
            })
        }
    }
}
