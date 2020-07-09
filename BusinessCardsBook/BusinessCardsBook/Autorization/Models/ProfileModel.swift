//
//  ProfileModel.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

struct ProfileModel: Codable {

    var userImage: Data?
    var name: String

    var userPhoneNumber: String?
    var userSocialNetworkID: String?

    var isAllowToShareProfileData: Bool
    var askPermissionEveryTime: Bool

    func getImage() -> UIImage? {
           if let data = self.userImage {
               return UIImage(data: data)
           }
           return nil
       }

       mutating func set(image: UIImage?) {
           self.userImage = image?.jpegData(compressionQuality: 0.5)
       }
}
