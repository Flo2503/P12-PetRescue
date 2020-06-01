//
//  ChangePasswordViewController.swift
//  PetRescue
//
//  Created by Flo on 01/06/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var labelNewPassword: UILabel!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var checkNewPassword: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    @IBAction func dismissKeyboard(_ sender: Any) {
        newPassword.resignFirstResponder()
        checkNewPassword.resignFirstResponder()
    }

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
            labelNewPassword.text = "Mot de passe invalide"
            validateButton.layer.backgroundColor = UIColor.red.cgColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        securePassword()
        ItemSetUp.buttonSetUp([validateButton])
        ItemSetUp.textFieldSetUp([newPassword, checkNewPassword])
    }

    private func securePassword() {
        newPassword.isSecureTextEntry = true
        checkNewPassword.isSecureTextEntry = true
    }

    private func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }

    private func changePassword() {
        if let newPassword = newPassword.text {
            self.validateButton.isEnabled = false
            self.validateButton.layer.backgroundColor = Colors.customGreenLight.cgColor
            UserManager.updatePassword(password: newPassword, callback: { success in
                if success {
                   self.validateButton.layer.backgroundColor = Colors.customGreen.cgColor
                    self.labelNewPassword.text = "Mot de passe modifié avec succès"
                } else {
                    self.labelNewPassword.text = "Erreur reéseau, merci de réessayer"
                    self.validateButton.isEnabled = true
                    self.validateButton.layer.backgroundColor = UIColor.red.cgColor
                }
            })
        }
    }
}
