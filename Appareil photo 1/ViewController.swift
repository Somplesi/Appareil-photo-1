//
//  ViewController.swift
//  Appareil photo 1
//
//  Created by Rodolphe DUPUY on 07/10/2020.
//  Copyright © 2020 Rodolphe DUPUY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageViewChoisie: UIImageView!
    @IBOutlet weak var noImageLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if imageViewChoisie.image == nil {
            noImageLabel.isHidden = false
        } else {
            noImageLabel.isHidden = true
        }
    }
    
    @IBAction func editingSwitch(_ sender: UISwitch) {
        if sender.isOn {
            imagePicker.allowsEditing = true
        } else {
            imagePicker.allowsEditing = false
        }
        
    }
    
    @IBAction func prendrePhoto(_ sender: UIButton) {
        // Préparer l'alerte
        let alerteActionSheet = UIAlertController(title: "Prendre une photo", message: "Choisissez le média", preferredStyle: .actionSheet) // Création de l'objet Action Sheet

        // Autoriser la Camera
        let camera = UIAlertAction(title: "Appareil photo", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) { // si Camera dispo ?
                self.presentWithSource(.camera)
            } else {
                let alerte = UIAlertController(title: "Erreur", message: "Aucun appareil photo n'est disponible", preferredStyle: .alert) // Création de l'objet Alert
                let annuler = UIAlertAction(title: "Je comprends", style: .destructive, handler: nil)
                alerte.addAction(annuler) // Configuration des boutons de l'objet Alert
                self.present(alerte, animated: true, completion: nil) // Afficher l'objet Alert
            }
        }

        // Autorisation de la Gallery
        let gallery = UIAlertAction(title: "Gallerie de photos", style: .default) { (action) in
            self.presentWithSource(.photoLibrary)
        }

        // Annuler la demande
        let cancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alerteActionSheet.addAction(camera)
        alerteActionSheet.addAction(gallery)
        alerteActionSheet.addAction(cancel)

        // Afficher la PopUp Alert sur iPad
        if let popover = alerteActionSheet.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.frame.midX, y: view.frame.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        present(alerteActionSheet, animated: true, completion: nil)
    }
    
    func presentWithSource(_ source: UIImagePickerController.SourceType)  {
        // Afficher la Gallery ou la Camera
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Ajouter dans plist: Privacy - Camera Usage Description & Privacy - Photo Galery Usage Description
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edite = info[.editedImage] as? UIImage {
            imageViewChoisie.image = edite
        } else if let originale = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageViewChoisie.image = originale
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
