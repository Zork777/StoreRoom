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
    @IBOutlet weak var selectThingOrBox: UISegmentedControl!
    
    
    var closeVC: (() -> ()) = {return}
    var getName: (() -> ()) = {return}
    
    
    @IBAction func buttonClose(_ sender: Any) {
        removeFromSuperview()
        closeVC()

    }
    
    @IBAction func buttonOk(_ sender: Any) {
        getName()
        removeFromSuperview()
        closeVC()
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
