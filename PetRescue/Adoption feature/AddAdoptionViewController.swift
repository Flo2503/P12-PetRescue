//
//  AddAdoptionViewController.swift
//  PetRescue
//
//  Created by Flo on 03/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class AddAdoptionViewController: UIViewController {

    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var animalName: UITextField!
    @IBOutlet weak var animalBreed: UITextField!
    @IBOutlet weak var animalGender: UITextField!
    @IBOutlet weak var animalAge: UITextField!
    @IBOutlet weak var locality: UITextField!
    @IBOutlet weak var infosTextView: UITextView!
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        animalName.resignFirstResponder()
        animalBreed.resignFirstResponder()
        animalGender.resignFirstResponder()
        animalAge.resignFirstResponder()
        locality.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ItemSetUp.textFieldSetUp([animalName, animalBreed, animalGender, animalAge, locality])
    }
}
