//
//  GetPhotoCamera.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 02.09.2022.
//

import Foundation
import UIKit


extension CollectionViewControllerContent: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func viewGetName() {
        let vc = UIViewController()
        let dialogGetNameThing = DialogGetNameThing.fromNib()


        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.modalPresentationStyle = .currentContext
        
        vc.view.addSubview(dialogGetNameThing)
        dialogGetNameThing.title.text = "Введите название"
        dialogGetNameThing.translatesAutoresizingMaskIntoConstraints = false
        dialogGetNameThing.leftAnchor.constraint(equalTo: vc.view.leftAnchor, constant: 8).isActive = true
        dialogGetNameThing.rightAnchor.constraint(equalTo: vc.view.rightAnchor, constant: -8).isActive = true
        dialogGetNameThing.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        dialogGetNameThing.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        dialogGetNameThing.closeVC = { vc.dismiss(animated: true) }
        dialogGetNameThing.getName = { [weak self] in
            guard let nameThing = dialogGetNameThing.textField.text else {
                showMessage(message: "get name: name thing is nil")
                return
            }

            switch dialogGetNameThing.selectThingOrBox.selectedSegmentIndex {
            case 0:
                self?.typeObjectForSave = .things
            case 1:
                self?.typeObjectForSave = .boxs
            case 2:
                self?.typeObjectForSave = .rooms
            default:
                self?.typeObjectForSave = .things
            }
            
            self?.objectForSave.name = nameThing
        }
        present(vc, animated: true)
    }

    func getPhotoInCamera(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        objectForSave.image = image
        dialogGetNameThing() // вызываем диалоговое окно для запроса названия
    }
}


