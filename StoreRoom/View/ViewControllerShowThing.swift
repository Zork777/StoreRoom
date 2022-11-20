//
//  ViewControllerShowThing.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 13.08.2022.
//

import UIKit

class ViewControllerShowThing: UIViewController {
    
    var label: String = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelTitle = UILabel()
        let imageThing = UIImageView()
        let buttonClose = UIButton(type: .system)
        
        let buttonTitle = NSLocalizedString("buttonTitle",
                                             value: "Close",
                                             comment: "button title for close view thing")
        buttonClose.setTitle(buttonTitle, for: .normal)
        buttonClose.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        labelTitle.text = label
        if image != nil {
                imageThing.image = image
        }
        
        view.addSubview(imageThing)
        view.addSubview(labelTitle)
        view.addSubview(buttonClose)
        
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        buttonClose.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        buttonClose.centerYAnchor.constraint(equalTo: labelTitle.centerYAnchor).isActive = true

        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        labelTitle.sizeToFit()
        
        imageThing.translatesAutoresizingMaskIntoConstraints = false
        imageThing.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageThing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6).isActive = true
        imageThing.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6).isActive = true
        imageThing.contentMode = .scaleAspectFit
    }
    
    @objc func closeView(){
        dismiss(animated: true)
    }

}
