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
        
         let phoneNumberRegex = "^[6-9+]\\d{3,12}$"
               let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
               let isValidPhone = phoneTest.evaluate(with: self)
               return isValidPhone
    }
}
