//
//  ChangePasswordViewController.swift
//  PetRescue
//
//  Created by Flo on 01/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    // MARK: - Properties
    private let invalidPasswordAlert = "Mot de passe non valide"
    private let passwordUpdateAlert = "Mot de passe modifié avec succès"
    private let networkErrorAlert = "Erreur réseau, merci de réessayer"
    private let userManager = UserManager()

    // MARK: - Outlets
    @IBOutlet weak var labelNewPassword: UILabel!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var checkNewPassword: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    // MARK: - Actions
    ///Dismiss Keyboard
    @IBAction func dismissKeyboard(_ sender: Any) {
        newPassword.resignFirstResponder()
        checkNewPassword.resignFirstResponder()
    }

    ///Check passwords are equals and valid, check text fields are not empty and call "changePassword" when taped
    @IBAction func tapValidateButton(_ sender: Any) {
        let passwordsAreEquals = InputValuesManager.passwordsAreEquals(passwordOne: newPassword.text, passwordTwo: checkNewPassword.text)
        let isValidPassword = InputValuesManager.isValidPassword(password: newPassword.text?.trimmingCharacters(in: .whitespaces))
        let isValidSecondPassword = InputValuesManager.isValidPassword(password: checkNewPassword.text?.trimmingCharacters(in: .whitespaces))

        if passwordsAreEquals
            && isValidPassword
            && isValidSecondPassword &&
            fieldIsNotEmpty([newPassword, checkNewPassword]) {
            changePassword()
        } else {
            labelNewPassword.text = invalidPasswordAlert
            validateButton.layer.backgroundColor = UIColor.red.cgColor
        }
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        securePassword()
        ItemSetUp.buttonSetUp([validateButton])
        ItemSetUp.textFieldSetUp([newPassword, checkNewPassword])
    }

    ///Hide user input text
    private func securePassword() {
        newPassword.isSecureTextEntry = true
        checkNewPassword.isSecureTextEntry = true
    }

    ///Check fields are not empty
    private func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }

    ///Call "updatePassword" updating password on user realtime database
    private func changePassword() {
        if let newPassword = newPassword.text {
            self.validateButton.isEnabled = false
            self.validateButton.layer.backgroundColor = Colors.customLightGreen.cgColor
            userManager.updatePassword(password: newPassword, callback: { success in
                if success {
                    self.validateButton.layer.backgroundColor = Colors.customGreen.cgColor
                    self.labelNewPassword.text = self.passwordUpdateAlert
                } else {
                    self.labelNewPassword.text = self.networkErrorAlert
                    self.validateButton.isEnabled = true
                    self.validateButton.layer.backgroundColor = UIColor.red.cgColor
                }
            })
        }
    }
}
