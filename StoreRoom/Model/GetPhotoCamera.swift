//
//  GetPhotoCamera.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 02.09.2022.
//

import Foundation
import UIKit


extension CollectionViewControllerContent: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func testViewGetPhotoCamera() {
        let base = BaseCoreData()
        let vc = UIViewController()
        let dialogGetNameThing = DialogGetNameThing.fromNib()
        var nameThing = "*"
        
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
        present(vc, animated: true)


        

        
//        let viewMessage = UIView()
//        viewMessage.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
//        let buttonCancel = UIButton(type: .close)
//        let buttonOk = UIButton(type: .system, primaryAction: UIAction(title: "OK", handler: { _ in
//            print ("tapped")
//        }))
//        let textField = UITextField()
//        textField.addAction(UIAction(title:"1", handler: { action in
//            let textField = action.sender as! UITextField
//            print("Text is \(textField.text ?? "")")
//        }), for: .editingChanged)
//        viewMessage.addSubview(buttonCancel)
//        viewMessage.addSubview(buttonOk)
//        viewMessage.addSubview(textField)
//        textField.topAnchor.constraint(equalTo: viewMessage.topAnchor).isActive = true
//        textField.leftAnchor.constraint(equalTo: viewMessage.leftAnchor).isActive = true
//        textField.rightAnchor.constraint(equalTo: viewMessage.rightAnchor).isActive = true
//        textField.bottomAnchor.constraint(equalTo: viewMessage.bottomAnchor).isActive = true
//        buttonCancel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16).isActive = true
//        buttonCancel.leftAnchor.constraint(equalTo: viewMessage.leftAnchor).isActive = true
//        buttonCancel.rightAnchor.constraint(equalTo: buttonOk.leftAnchor, constant: 32).isActive = true
//        buttonCancel.bottomAnchor.constraint(equalTo: viewMessage.bottomAnchor).isActive = true
//        buttonOk.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16).isActive = true
//        buttonOk.rightAnchor.constraint(equalTo: viewMessage.leftAnchor).isActive = true
//        buttonOk.bottomAnchor.constraint(equalTo: viewMessage.bottomAnchor).isActive = true
//        viewMessage.translatesAutoresizingMaskIntoConstraints = false
//        viewMessage.backgroundColor = .red
//        self.view.addSubview(viewMessage)
    }
    
    func testGetPhotoCamera() {
        let base = BaseCoreData()
        
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
            let thingObject = Object(name: nameThing, image: .add)
            guard let idBoxOrRoom = self?.idBoxOrRoom else {
                showMessage(message: "get name: ID box is nil")
                return
            }
            guard let baseObject = base.findBoxOrRoomByID(id: idBoxOrRoom) else {
                showMessage(message: "get name: ID box not found in base")
                return
            }
            base.saveObject(objectForSave: thingObject, base: .things, boxOrRoom: baseObject)
            self?.collectionViewThings.reloadData()
        }))
        
        dialog.addAction(actionCancel)
        dialog.addAction(nameTextField)
        
        present(dialog, animated: true)

    }
    
    
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
