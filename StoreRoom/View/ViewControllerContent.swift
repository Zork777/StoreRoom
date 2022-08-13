//
//  ViewControllerContent.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 10.08.2022.
//

import UIKit

class ViewControllerContent: UIViewController {
    
    var idBoxOrRoom: UUID? = nil
    private var things: [ItemCollection]?
    private let base = BaseCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if idBoxOrRoom != nil {
                showMessage(message: ValidationError.notFoundIdRoom.localizedDescription)
                fatalError()}
        things = base.contentBoxRoom(idBoxOrRoom: idBoxOrRoom!)?.map({ EntityThings in
                                                                EntityThings.convertToItemCollection()})
        
        
    }
    

}
