//
//  MyProfilViewController.swift
//  PetRescue
//
//  Created by Flo on 23/05/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum ProfilSection: Int {
    case first
    case second
    case third
    case fourth
}

class MyProfilViewController: UIViewController {

    private let userId = Auth.auth().currentUser?.uid
    private var imagePicker = UIImagePickerController()
    private var unwindIdentifier = "unwindToLogin"
    private let passwordSegue = "segueToChangePassword"
    private let editEmailSegue = "segueToEditEmail"
    private let cellTitle = ["Nom", "Prénom", "Adresse mail"]
    private let section = ["Mes informations", "Modifier mon mot de passe", "Modifier mon adresse mail", "Déconnexion"]
    private var userInfo: [String] = []
    private var user: UserManager?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var choosePictureButton: UIButton!
    @IBOutlet weak var savePictureButton: UIButton!

    @IBAction func unwindToMyProfil(segue: UIStoryboardSegue) { }

    @IBAction func tapChoosePicture(_ sender: Any) {
        chooseImage()
    }

    @IBAction func tapSavePicture(_ sender: Any) {
        if let name = user?.name, let userId = userId, let image = userPicture.image {
            UserManager.uploadUserPicture(name: name, userId: userId, image: image, completion: { url in
                let ref = Database.database().reference()
                if let userID = Auth.auth().currentUser?.uid, let url = url {
                    ref.child("users").child(userID).updateChildValues(["userPicture": url])
                }
            })
        }
    }

    override func viewDidLoad() {
        self.tableView.reloadData()
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        ItemSetUp.makeRounded(userPicture)
        ItemSetUp.makeRoundedButton([savePictureButton, choosePictureButton])
        checkPicture()
    }

    private func importDetails() {
        if let name  = user?.name, let firstName = user?.firstName, let email = user?.emailAddress {
            userInfo.append(name)
            userInfo.append(firstName)
            userInfo.append(email)
        }
    }

    private func checkPicture() {
        while userPicture.image == UIImage(named: "default_user") {
            savePictureButton.isEnabled = false
            savePictureButton.layer.backgroundColor = UIColor.red.cgColor
        }
    }
}

extension MyProfilViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ProfilSection(rawValue: section)! {
        case .first:
            return cellTitle.count
        case .second:
            return 1
        case .third:
            return 1
        case .fourth:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myProfilCell", for: indexPath)
        let passwordCell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell", for: indexPath)
        let editEmailCell = tableView.dequeueReusableCell(withIdentifier: "editEmailCell", for: indexPath)
        let logoutCell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)

        switch ProfilSection(rawValue: indexPath.section)! {
        case .first:
            cell.textLabel?.text = cellTitle[indexPath.row]
            if let currentUser = userId {
                UserManager.retrieveUser(userId: currentUser, callback: { currentUser in
                    self.user = currentUser
                    self.importDetails()
                    cell.detailTextLabel?.text = self.userInfo[indexPath.row]
                    self.tableView.reloadData()
                })
            }
            return cell
        case .second:
            return passwordCell
        case .third:
            return editEmailCell
        case .fourth:
            return logoutCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ProfilSection(rawValue: indexPath.section)! {
        case .first:
            print("Do nothing")
        case .second:
            performSegue(withIdentifier: passwordSegue, sender: self)
        case .third:
            performSegue(withIdentifier: editEmailSegue, sender: self)
        case .fourth:
            let alert = UIAlertController(title: "Vous êtes sur le point d'être déconnecté", message: "Continuer ?", preferredStyle: .actionSheet)
            let logout = UIAlertAction(title: "Oui", style: .default, handler: { _ in
                if UserManager.signOut() == true {
                    self.performSegue(withIdentifier: self.unwindIdentifier, sender: self)
                } else {
                    print("logout failure")
                }
            })
            let cancelAction = UIAlertAction(title: "Non", style: .cancel)
            alert.addAction(logout)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}

extension MyProfilViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Photo library access
      @objc private func libraryAccess() {
          imagePicker.sourceType = .photoLibrary
          imagePicker.allowsEditing = false
          present(imagePicker, animated: true, completion: nil)
      }

      // Camera access
      @objc private func cameraAccess() {
          if UIImagePickerController.isSourceTypeAvailable(.camera) {
              imagePicker.sourceType = .camera
              imagePicker.allowsEditing = false
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
        userPicture.image = image
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
