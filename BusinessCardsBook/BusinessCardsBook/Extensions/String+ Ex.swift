//
//  String+ Ex.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/12/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import Foundation

extension String {
    
    func isPhoneNumber() -> Bool {
        let phoneNumberRegex = "[0-9+]{1}" + "@" + "[0-9]{2,12}"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phoneNumberPredicate.evaluate(with: self)
    }
}
