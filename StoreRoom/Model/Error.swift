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
            return failedSaveCoreData
        case .failedDeleteInCoreData:
            return failedDeleteCoreData
        case .failedMarkOrderForDelete:
            return failedDeleteMarkOrder
        case .notFoundIdRoom:
            return notFoundIdRoomBox
        }
    }
}
