//
//  Gradient Extension.swift
//  PetRescue
//
//  Created by Flo on 24/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func setGradientBackground(colorOne: UIColor, colotTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colotTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
