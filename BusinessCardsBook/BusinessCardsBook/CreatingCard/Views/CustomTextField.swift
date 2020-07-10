//
//  CustomTextField.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.font = .italicSystemFont(ofSize: 20)
        self.textAlignment = .center
        self.borderStyle = .roundedRect
        self.backgroundColor = .lightGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
