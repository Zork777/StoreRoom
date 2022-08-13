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
    case failedMarkOrderForDelete
    case notFoundIdRoom
    
    var errorDescription: String? {
        switch self {
        case .failedSavingInCoreData:
            return "failed save in Core Data"
        case .failedDeleteInCoreData:
            return "failed delete in Core Data"
        case .failedMarkOrderForDelete:
            return "failed mark delete order"
        case .notFoundIdRoom:
            return "id room or box is null"
        }
    }
}
