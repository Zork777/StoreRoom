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
    var id: UUID
}

///данные объекта для сохранения в кладовке или коробке или сама коробка
struct Object {
    var id: UUID = UUID()
    var name: String?
    var image: UIImage?
    var imageData: Data?{
        guard let image = image else {return nil}
        return image.jpegData(compressionQuality: 1) ?? nil
    }
    var imageDataSmall:Data? {
        guard let image = image else {return nil}
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)).jpegData(compressionQuality: 1) ?? nil
    }
}
