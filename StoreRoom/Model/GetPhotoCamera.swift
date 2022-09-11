//
//  GetPhotoCamera.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 02.09.2022.
//

import Foundation
import UIKit


extension CollectionViewControllerContent: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func alertGetName() {
        let dialog = UIAlertController(title: "", message: "название?", preferredStyle: .alert)
        dialog.addTextField()
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
        let nameTextField = UIAlertAction(title: "OK", style: .default, handler: ({ _ in
            guard let name = dialog.textFields else {
                showMessage(message: "get name: name thing is nil")
                return
            }
            self.thingForSave.name = name[0].text ?? "_"
        }))
        
        dialog.addAction(actionCancel)
        dialog.addAction(nameTextField)
        present(dialog, animated: true)
    }

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
            
            self?.thingForSave.name = nameThing
                
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
        thingForSave.image = image
        dialogGetNameThing() // вызываем диалоговое окно для запроса названия
        
    }
}

extension UIView {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
            else { fatalError("missing expected nib named: \(name)") }
        guard
            let view = nib.first as? Self
            else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}
