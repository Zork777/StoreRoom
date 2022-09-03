//
//  AlertWindow.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.08.2022.
//

import Foundation
import UIKit

///Выводим диалог
func dialogMessage(message: String, funcOk: @escaping () -> (), funcCancel: @escaping ()->()){
    let dialog = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    let actionOk = UIAlertAction(title: "OK", style: .default, handler: {_ in funcOk() })
    let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: {_ in funcCancel() })
    let messageFont  = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
    let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
    dialog.setValue(messageAttrString, forKey: "attributedMessage")
    dialog.addAction(actionCancel)
    dialog.addAction(actionOk)
    let vc = UIApplication.topViewController()
    vc?.present(dialog, animated: true)
}


///Выводим сообщение
func showMessage(message: String) {
    let dialog = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default)
    dialog.addAction(action)
    let vc = UIApplication.topViewController()
    vc?.present(dialog, animated: true)
    debugPrint (message)
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
    
    class func topNavigationController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {
        
        if let nav = viewController as? UINavigationController {
            return nav
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected.navigationController
            }
        }
        return viewController?.navigationController
    }
}
