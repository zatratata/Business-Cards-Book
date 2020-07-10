//
//  YellowBackgroundImageView.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class YellowBackgroundImageView: UIImageView {

    private let yellowPaper: UIImage? = UIImage(named: "leather")

    init() {
        super.init(image: self.yellowPaper)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
