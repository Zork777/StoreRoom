//
//  CalculateSizeCell.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 13.08.2022.
//

import Foundation
import UIKit

class CalculateSizeCell {
    private var itemsPerRow: CGFloat = 1
    private var widthView: CGFloat
    let sectionInsets = UIEdgeInsets(
                                              top: 16.0,
                                              left: 16.0,
                                              bottom: 16.0,
                                              right: 16.0)
    var sizeCell = CGSize()
    
    init(itemsPerRow: CGFloat,
         widthView: CGFloat = UIWindow(frame: UIScreen.main.bounds).bounds.width){
        
        self.itemsPerRow = itemsPerRow
        self.widthView = widthView
        self.sizeCell = calculateSizeCell()
        
    }
    ///MARK: рассчет размера ячейки
        func calculateSizeCell() -> CGSize{
            let paddingSpace = sectionInsets.left * (itemsPerRow) + sectionInsets.right
            let availableWidth = widthView - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
}
