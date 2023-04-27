//
//  GetPhotoCamera.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 02.09.2022.
//

import Foundation
import UIKit


extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func viewGetName() {
        let vc = UIViewController()
        let dialogGetNameThing = DialogGetNameThing.fromNib()


        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.modalPresentationStyle = .currentContext
        
        vc.view.addSubview(dialogGetNameThing)
        dialogGetNameThing.translatesAutoresizingMaskIntoConstraints = false
        dialogGetNameThing.leftAnchor.constraint(equalTo: vc.view.leftAnchor, constant: 8).isActive = true
        dialogGetNameThing.rightAnchor.constraint(equalTo: vc.view.rightAnchor, constant: -8).isActive = true
        dialogGetNameThing.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        dialogGetNameThing.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: -70).isActive = true
        dialogGetNameThing.setupInit()
        
        //настриваем кол-во выводимых типов объекта для записи
        if dataManager.getObjectBoxOrRoom()?.entity.name == nil {
            dialogGetNameThing.selectThingOrBox.removeSegment(at: 1, animated: true)
            dialogGetNameThing.selectThingOrBox.removeSegment(at: 0, animated: true)
            dialogGetNameThing.selectThingOrBox.selectedSegmentIndex = 0
        }
        else {
            dialogGetNameThing.selectThingOrBox.removeSegment(at: 2, animated: true)
            dialogGetNameThing.selectThingOrBox.selectedSegmentIndex = 0
        }
        
        dialogGetNameThing.closeVC = { vc.dismiss(animated: true) }
        dialogGetNameThing.getName = { [weak self] in
            guard let nameThing = dialogGetNameThing.textField.text else {
                let messageError = NSLocalizedString("errorGetNameThingIsNil",
                                                     value: "get name: name thing is nil",
                                                     comment: "message error when get name thing")
                showMessage(message: messageError)
                return
            }
            
            if dialogGetNameThing.selectThingOrBox.numberOfSegments == 1 {
                self?.typeObjectForSave = .rooms // новая кладовка, поэтому сразу пишем тип кладовка
            }
            else {
                switch dialogGetNameThing.selectThingOrBox.selectedSegmentIndex {
                case 0:
                    self?.typeObjectForSave = .things
                case 1:
                    self?.typeObjectForSave = .boxs
                default:
                    self?.typeObjectForSave = .things
                }
            }
            self?.objectForSave.name = nameThing != "" ? nameThing:" "
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


