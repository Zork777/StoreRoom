//
//  GetPhotoCamera.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 02.09.2022.
//

import Foundation
import UIKit


extension CollectionViewControllerContent: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func getPhotoCamera(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true)
        let base = BaseCoreData()
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        var nameThing = "*"
        let dialog = UIAlertController(title: "", message: "название?", preferredStyle: .alert)
        dialog.addTextField()
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
        let nameTextField = UIAlertAction(title: "OK", style: .default, handler: ({ [weak self] _ in
            guard let name = dialog.textFields else {
                showMessage(message: "get name: name thing is nil")
                return
            }
            nameThing = name[0].text ?? "_"
            let thingObject = Object(name: nameThing, image: image)
            guard let idBoxOrRoom = self?.idBoxOrRoom else {
                showMessage(message: "get name: ID box is nil")
                return
            }
            guard let baseObject = base.findBoxOrRoomByID(id: idBoxOrRoom) else {
                showMessage(message: "get name: ID box not found in base")
                return
            }
            base.saveObject(objectForSave: thingObject, base: .things, boxOrRoom: baseObject)
        }))
        
        dialog.addAction(actionCancel)
        dialog.addAction(nameTextField)
        present(dialog, animated: true)

    }
    
}
