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

    @IBAction func didTapeValidate(_ sender: Any) {

        let isEmailAddressValid = ValueManager.isValidEmailAddress(emailAddressString: emailAdress.text!, textField: emailAdress)
        let passwordAreEquals = ValueManager.passwordsAreEquals(passwordOne: password.text, passwordTwo: passwordValidation.text, fieldOne: password, fieldTwo: passwordValidation)
        let fieldIsNotEmpty = ValueManager.fieldIsNotEmpty([passwordValidation, password, emailAdress])
        let isValidPassword = ValueManager.isValidPassword(password: password.text, field: password)
        let isValidSecondPassword = ValueManager.isValidPassword(password: passwordValidation.text, field: passwordValidation)
        let userDoNotExist = UserManager.userDoesNotExist(email: emailAdress.text, label: labelSignUp, button: validateButton)

        if isEmailAddressValid &&
            passwordAreEquals &&
            fieldIsNotEmpty &&
            isValidPassword &&
            isValidSecondPassword &&
            userDoNotExist {
            UserManager.createUser(email: emailAdress.text!, password: password.text!)
            performSegue(withIdentifier: identifier, sender: self)
        }
    }

    @IBAction func unwindToSignUp(segue: UIStoryboardSegue) { }

    @IBAction func resetPassword(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ValueManager.securePassword([password, passwordValidation])
        DisplaySetUp.buttonsetUp(validateButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        DisplaySetUp.textFieldSetUp([emailAdress, password, passwordValidation])
    }
}
