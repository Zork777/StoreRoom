//
//  DialogGetNameThing.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 10.09.2022.
//

import UIKit

class DialogGetNameThing: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var closeVC: (() -> ()) = {return}
    
    @IBAction func buttonClose(_ sender: Any) {
        removeFromSuperview()
        closeVC()

    }
    
    @IBAction func buttonOk(_ sender: Any) {
        guard let name = textField.text else {
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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInit()
    }
    
    
    func setupInit() {

    }
}
