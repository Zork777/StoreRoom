//
//  CollectionViewCell.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 10.08.2022.
//

import UIKit

struct Cell {
    var labelName: String
    var image: UIImage
    var sizeCell: CGSize
}

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
//        contentView.layer.borderColor = UIColor.systemGray.cgColor
//        contentView.layer.borderWidth = CGFloat(1)
    }
    
    func config(cell: Cell) {
        labelName.text = cell.labelName
        DispatchQueue.main.async {
            [weak self] in
            self?.image.image = cell.image.preparingThumbnail(of: cell.sizeCell)
        }
    }
}
