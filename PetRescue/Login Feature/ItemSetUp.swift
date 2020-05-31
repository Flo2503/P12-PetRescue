//
//  DisplaySetUp.swift
//  PetRescue
//
//  Created by Flo on 29/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import UIKit

class ItemSetUp {

    static func textFieldSetUp(_ textField: [UITextField]) {
        for item in textField {
            item.layer.borderWidth = 2
            item.layer.borderColor = Colors.customGreen.cgColor
            item.layer.cornerRadius = item.frame.size.height / 2
            item.borderStyle = .none
        }
    }

    static func buttonSetUp(_ item: [UIButton]) {
        for button in item {
            button.layer.cornerRadius = button.frame.size.height / 2
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.backgroundColor = Colors.customGreen.cgColor
        }
    }

    static func textViewSetUp(_ textView: UITextView) {
        textView.layer.cornerRadius = textView.frame.size.height / 15
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Colors.customGreen.cgColor
    }

    static func makeRounded(_ image: UIView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = Colors.customGreen.cgColor
    }

    static func makeRoundedButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.customGreen.cgColor
    }
}
