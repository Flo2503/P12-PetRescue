//
//  AddAdoptionViewController.swift
//  PetRescue
//
//  Created by Flo on 03/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit

class AddAdoptionViewController: UIViewController {
    // MARK: - Properties, instances
    private var imagePicker = UIImagePickerController()
    private let unwindIdentifier = "segueToMainFeed"
    private let user = UserManager.currentUserId
    private let adManager = AdManager()

    // MARK: - PickerView and SelectedSegment properties
    lazy var ageIndex = agePickerView.selectedRow(inComponent: 0).self
    lazy var age = ageChoice[ageIndex]
    lazy var gender = (animalGender.selectedSegmentIndex == 0) ? "Femelle" : "Mâle"

    // MARK: - Outlets
    @IBOutlet weak var animalName: UITextField!
    @IBOutlet weak var animalKind: UITextField!
    @IBOutlet weak var animalGender: UISegmentedControl!
    @IBOutlet weak var locality: UITextField!
    @IBOutlet weak var infosTextView: UITextView!
    @IBOutlet weak var animalPicture: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var agePickerView: UIPickerView!
    @IBOutlet weak var addPictureButton: UIButton!

    // MARK: - Actions
    @IBAction func addFirstPicture(_ sender: Any) {
        chooseImage()
    }

    @IBAction func tapOnCreateAd(_ sender: Any) {
        let textIsNotEmpty = fieldIsNotEmpty([animalName, animalKind, locality])
        if textIsNotEmpty && !infosTextView.text.isEmpty {
            createAd()
        } else {
            addButton.setTitleColor(.red, for: .normal)
        }
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        animalName.resignFirstResponder()
        animalKind.resignFirstResponder()
        animalGender.resignFirstResponder()
        locality.resignFirstResponder()
        infosTextView.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ItemSetUp.makeRounded(animalPicture)
        ItemSetUp.textViewSetUp(infosTextView)
        ItemSetUp.textFieldSetUp([animalName, animalKind, locality])
        ItemSetUp.makeRoundedButton([addPictureButton])
    }

    override func viewDidAppear(_ animated: Bool) {
        if NetworkManager.connection() == false {
            NetworkManager.alert(controller: self)
            addButton.setTitleColor(.red, for: .normal)
            addButton.isEnabled = false
        }
    }

    ///Check text field ins't empty
    private func fieldIsNotEmpty(_ textField: [UITextField]) -> Bool {
        for item in textField {
            guard !item.text!.isEmpty else {
                return false
            }
        }
        return true
    }

    ///Allow to create new ad with AdManager object.  Call "uploadMedia" to push animal picture on storage. Call "createAd" pushing animal datas on realtime database.
    private func createAd() {
        guard let name = animalName.text,
            let kind = animalKind.text,
            let locality = locality.text,
            let details = infosTextView.text,
            let user = user,
            let image = animalPicture.image else { return }
        adManager.uploadMedia(name: name, image: image, completion: { url in
            guard let url = url else { return }
            let animal = Ad(age: self.age,
                                       animalImage: url,
                                       details: details,
                                       gender: self.gender,
                                       kind: kind,
                                       locality: locality,
                                       name: name,
                                       userId: user)
            self.adManager.createAd(animal: animal)
        })
            performSegue(withIdentifier: unwindIdentifier, sender: self)
    }
}

// MARK: - Extensions
///Camera and library access extension
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
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        animalPicture.image = image
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
///PickerView extension
extension AddAdoptionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageChoice.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageChoice[row]
    }
}
