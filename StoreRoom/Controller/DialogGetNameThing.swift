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
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonOk: UIButton!
    
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupInit() {

        let labelTitle = NSLocalizedString("EnterName", value: "Enter a name", comment: "Title in dialog getNameThing")
        let segmentNameFirst = NSLocalizedString("Thing", comment: "First segment name in dialog getNameThing")
        let segmentNameSecond = NSLocalizedString("Box", comment: "Second segment name in dialog getNameThing")
        let segmentNameThird = NSLocalizedString("Root", comment: "Third segment name in dialog getNameThing")
        title.text = labelTitle
        buttonClose.setTitle(buttonCloseTitle, for: .normal)
        buttonOk.setTitle(buttonOkTitle, for: .normal)
        selectThingOrBox.setTitle(segmentNameFirst, forSegmentAt: 0)
        selectThingOrBox.setTitle(segmentNameSecond, forSegmentAt: 1)
        selectThingOrBox.setTitle(segmentNameThird, forSegmentAt: 2)
    }
}
