//
//  DialogConfirmDelete.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 15.11.2022.
//

import UIKit

class DialogConfirmDelete: UIView {
    
    var functionDelete: (() -> ()) = {return}
    var functionCloseVC: (() -> ()) = {return}

    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var objectName: UILabel!
    @IBAction func buttonDelete(_ sender: Any) {
        functionDelete()
        removeFromSuperview()
        functionCloseVC()
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        removeFromSuperview()
        functionCloseVC()
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        guard let window = window else {return}
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = window.frame.height
        }, completion: nil)
    }
    
    func setupInit(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        
        buttonCancel.setTitle(buttonCancelTitle, for: .normal)
        buttonDelete.setTitle(buttonDeleteTitle, for: .normal)
        
        guard let window = window else {return}
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.frame.origin.y =  -window.frame.height * 0.3},
                    completion: nil)
    }
    

}
