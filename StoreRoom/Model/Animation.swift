//
//  Animation.swift
//  StoreRoom
//
//  Created by Евгений Захаров on 04.10.2022.
//

import Foundation
import UIKit

func animationTextShake(label: UILabel){
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.8, 1]
    animation.duration = 0.4
    animation.values = [0, 10, -10, 10, -5, 5, -5, 0]
    animation.isAdditive = true
    label.layer.add(animation, forKey: "shake")
}
