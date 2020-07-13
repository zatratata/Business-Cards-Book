//
//  UIAlertController+Ex.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/13/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
