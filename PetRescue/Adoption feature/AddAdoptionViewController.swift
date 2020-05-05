//
//  AddAdoptionViewController.swift
//  PetRescue
//
//  Created by Flo on 03/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class AddAdoptionViewController: UIViewController {

    private var imagePicker = UIImagePickerController()

    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var animalName: UITextField!
    @IBOutlet weak var animalBreed: UITextField!
    @IBOutlet weak var animalGender: UITextField!
    @IBOutlet weak var animalAge: UITextField!
    @IBOutlet weak var locality: UITextField!
    @IBOutlet weak var infosTextView: UITextView!
    @IBOutlet weak var firstPicture: UIButton!
    @IBOutlet weak var secondPicture: UIButton!
    @IBOutlet weak var thirdPicture: UIButton!

    @IBAction func addFirstPicture(_ sender: Any) {
        chooseImage()
    }

    @IBAction func addSecondPicture(_ sender: Any) {
        chooseImage()
    }

    @IBAction func addThirdPicture(_ sender: Any) {
        chooseImage()
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        animalName.resignFirstResponder()
        animalBreed.resignFirstResponder()
        animalGender.resignFirstResponder()
        animalAge.resignFirstResponder()
        locality.resignFirstResponder()
        infosTextView.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ItemSetUp.textFieldSetUp([animalName, animalBreed, animalGender, animalAge, locality])
    }
}

extension AddAdoptionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Photo library access
      @objc private func libraryAccess() {
          imagePicker.sourceType = .photoLibrary
          imagePicker.allowsEditing = true
          present(imagePicker, animated: true, completion: nil)
      }

      // Camera access
      @objc private func cameraAccess() {
          if UIImagePickerController.isSourceTypeAvailable(.camera) {
              imagePicker.sourceType = .camera
              imagePicker.allowsEditing = true
              present(imagePicker, animated: true, completion: nil)
          } else {
            let alert = UIAlertController(title: "Appareil photo non valide", message: "Choisissez une photo dans la librairie", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @objc private func chooseImage() {
        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: "Image", message: "Choisissez une source", preferredStyle: .actionSheet)
        let openCamera = UIAlertAction(title: "Appareil photo", style: .default, handler: { _ in
            self.cameraAccess()
        })
        let openLibrary = UIAlertAction(title: "Librairie", style: .default, handler: { _ in
            self.libraryAccess()
        })
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
        optionMenu.addAction(openCamera)
        optionMenu.addAction(openLibrary)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        firstPicture.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
