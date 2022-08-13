//
//  ViewControllerShowThing.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 13.08.2022.
//

import UIKit

class ViewControllerShowThing: UIViewController {

    @IBOutlet weak var imageThing: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var label: String = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageThing.contentMode = .scaleAspectFit
        imageThing.layer.cornerRadius = 5
        labelTitle.text = label
        if image != nil {
                imageThing.image = image}
        imageThing.translatesAutoresizingMaskIntoConstraints = true

    }

}
