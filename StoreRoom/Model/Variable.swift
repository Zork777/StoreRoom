//
//  Variable.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.08.2022.
//

import Foundation
import CoreData
import UIKit

struct ItemCollection {
    var name: String
    var image: UIImage
}

struct Object {
    var name: String
    var image: UIImage
    var imageData: Data?{
        return image.jpegData(compressionQuality: 1) ?? nil
    }
    var imageDataSmall:Data? {
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)).jpegData(compressionQuality: 1) ?? nil
    }
}
