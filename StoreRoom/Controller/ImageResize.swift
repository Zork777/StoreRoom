//
//  ImageResize.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 10.08.2022.
//

import Foundation
import UIKit

extension UIImage {
    func setProfileImage(imageToResize: UIImage, onImageView: UIImageView) -> UIImage?
    {
        let width = imageToResize.size.width
        let height = imageToResize.size.height

        var scaleFactor: CGFloat

        if(width > height)
            {
                scaleFactor = onImageView.frame.size.height / height;
            }
        else
            {
                scaleFactor = onImageView.frame.size.width / width;
            }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        imageToResize.draw(in: CGRect(x: 0, y: 0, width: width * scaleFactor, height: height * scaleFactor))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
