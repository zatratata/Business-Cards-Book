//
//  TextField+Ex.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

extension UITextField {
    func setCustomPlaceholder(_ text: String) {
        self.attributedPlaceholder = NSAttributedString(
        string: text,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                     NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 17)])
    }
}
