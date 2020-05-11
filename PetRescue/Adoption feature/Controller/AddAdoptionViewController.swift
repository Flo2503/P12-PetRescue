//
//  AddAdoptionViewController.swift
//  PetRescue
//
//  Created by Flo on 03/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import Firebase

class AddAdoptionViewController: UIViewController {

    private var imagePicker = UIImagePickerController()
    private let unwindIdentifier = "segueToMainFeed"
    private let alertTextIsEmpty = "Informations manquantes :"
    private let ref = Database.database().reference(withPath: "ads")
    private let user = Auth.auth().currentUser!.uid.description

    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var animalName: UITextField!
    @IBOutlet weak var animalKind: UITextField!
    @IBOutlet weak var animalGender: UITextField!
    @IBOutlet weak var animalAge: UITextField!
    @IBOutlet weak var locality: UITextField!
    @IBOutlet weak var infosTextView: UITextView!
    @IBOutlet weak var picture: UIButton!
    @IBOutlet weak var addButton: UIButton!

    @IBAction func addFirstPicture(_ sender: Any) {
        chooseImage()
    }

    @IBAction func tapOnCreateAd(_ sender: Any) {
        let textIsNotEmpty = InputValuesManager.fieldIsNotEmpty([animalName, animalKind, animalGender, animalAge, locality])
        if textIsNotEmpty {
            createAd()
        } else {
            addButton.setTitleColor(.red, for: .normal)
            addLabel.text = alertTextIsEmpty
        }
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        animalName.resignFirstResponder()
        animalKind.resignFirstResponder()
        animalGender.resignFirstResponder()
        animalAge.resignFirstResponder()
        locality.resignFirstResponder()
        infosTextView.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ItemSetUp.textFieldSetUp([animalName, animalKind, animalGender, animalAge, locality])
    }

    private func createAd() {
        guard let name = animalName.text,
            let kind = animalKind.text,
            let gender = animalGender.text,
            let age = animalAge.text,
            let locality = locality.text,
            let details = infosTextView.text,
            let image = picture.imageView?.image else { return }
        AdManager.uploadMedia(name: name, image: image, completion: { url in
                       guard let url = url else { return }
                       let animal = AdManager(age: age,
                                       animalImage: url,
                                       details: details,
                                       gender: gender,
                                       kind: kind,
                                       locality: locality,
                                       name: name,
                                       userId: self.user)

            let animalRef = self.ref.childByAutoId()

            animalRef.setValue(animal.toAnyObject())
        })
            performSegue(withIdentifier: unwindIdentifier, sender: self)
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
            let alert = UIAlertController(title: "Appareil photo non valide", message: "Choisissez une photo dans la phototèque", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @objc private func chooseImage() {
        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: "Image", message: "Choisissez une source", preferredStyle: .actionSheet)
        let openCamera = UIAlertAction(title: "Prendre une photo", style: .default, handler: { _ in
            self.cameraAccess()
        })
        let openLibrary = UIAlertAction(title: "Phototèque", style: .default, handler: { _ in
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
        picture.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
