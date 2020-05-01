//
//  SignUpViewController.swift
//  PetRescue
//
//  Created by Flo on 25/04/2020.
//  Copyright © 2020 Flo. All rights reserved.

import UIKit

class SignUpViewController: NavBarSetUp {

    private let identifier = "segueToSignUpDetails"

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
        let fieldIsNotEmpty = InputValuesManager.fieldIsNotEmpty([passwordValidation, password, emailAdress])
        let isValidPassword = InputValuesManager.isValidPassword(password: password.text)
        let isValidSecondPassword = InputValuesManager.isValidPassword(password: passwordValidation.text)

        if isEmailAddressValid &&
            passwordsAreEquals &&
            fieldIsNotEmpty &&
            isValidPassword &&
            isValidSecondPassword {
            UserManager.createUser(email: emailAdress.text!, password: password.text!)
            performSegue(withIdentifier: identifier, sender: self)
        } else {
            print("no way")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        InputValuesManager.securePassword([password, passwordValidation])
        ItemSetUp.buttonsetUp(validateButton)
        ItemSetUp.textFieldSetUp([emailAdress, password, passwordValidation
        ])
        UserManager.signOut()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
}
