//
//  LabelForProfile.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class LabelForProfile: UILabel {

  override init(frame: CGRect) {
              super.init(frame: frame)

              self.font = .boldSystemFont(ofSize: 25)
              self.textAlignment = .center
              self.textColor = .white
          }

          required init?(coder: NSCoder) {
              fatalError("init(coder:) has not been implemented")
          }
}
