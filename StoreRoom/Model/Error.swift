//
//  Error.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.08.2022.
//

import Foundation

enum ValidationError: LocalizedError {
    case failedSavingInCoreData
    case failedDeleteInCoreData
    case failedSaveOrder
    case failedMarkOrderForDelete
    
    var errorDescription: String? {
        switch self {
        case .failedSavingInCoreData:
            return "failed save in Core Data"
        case .failedDeleteInCoreData:
            return "failed delete in Core Data"
        case .failedSaveOrder:
            return "failed save Order"
        case .failedMarkOrderForDelete:
            return "failed mark delete order"
        }
    }
}
