//
//  CollectionViewCell.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 10.08.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var image: UIImageView!
    var cornerRadius: CGFloat = 5.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelName.font = .preferredFont(forTextStyle: .subheadline)
        labelName.baselineAdjustment = .alignCenters
        labelName.textAlignment = .center
        labelName.adjustsFontSizeToFitWidth = true
        labelName.numberOfLines = 2
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = cornerRadius
        
        contentView.layer.cornerRadius = cornerRadius
//        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = CGFloat(1)

//        layer.cornerRadius = cornerRadius
//        layer.masksToBounds = false
//
//        layer.shadowRadius = cornerRadius
//        layer.shadowOpacity = 0.1
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        layer.shadowPath = UIBezierPath(
//            roundedRect: bounds,
//            cornerRadius: cornerRadius
//        ).cgPath
//    }
}
