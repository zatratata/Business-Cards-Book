//
//  ReusableLabel.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class ReusableLable: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.font = .italicSystemFont(ofSize: 22)
        self.textAlignment = .center
        self.textColor = .white
        self.lineBreakMode = .byWordWrapping
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
