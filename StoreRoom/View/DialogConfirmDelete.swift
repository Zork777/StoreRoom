//
//  DialogConfirmDelete.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 15.11.2022.
//

import UIKit

class DialogConfirmDelete: UIView {
    
    var functionDelete: (() -> ()) = {return}

    @IBOutlet weak var objectName: UILabel!
    @IBAction func buttonDelete(_ sender: Any) {
        functionDelete()
        removeFromSuperview()
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        removeFromSuperview()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupInit()
//    }
    
    override func willRemoveSubview(_ subview: UIView) {
        guard let window = window else {return}
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.frame.origin.y = window.frame.height
        }, completion: nil)
    }
    
    func setupInit() {
//        alpha = 0.5
//        modalTransitionStyle = UIModalTransitionStyle.coverVertical
//        modalPresentationStyle = .currentContext
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let window = window else {return}
        self.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: 0.2).isActive = true
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.frame.origin.y =  -window.frame.height * 0.3},
                    completion: nil)
    }
    

}
