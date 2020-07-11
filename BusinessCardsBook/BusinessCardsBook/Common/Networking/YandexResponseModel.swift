//
//  YandexResponseModel.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/11/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import Foundation

struct YandexResponseModel: Decodable {
    let response: Response
}

struct Response: Decodable {
    let geoObjectCollection: GeoObjectCollection
    
    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

struct GeoObjectCollection: Decodable {
    let featureMember: [FeatureMember]
}

struct FeatureMember: Decodable {
    let geoObject: GeoObject
    
    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

struct GeoObject: Decodable {
    let point: GeoPoint
    
    enum CodingKeys: String, CodingKey {
           case point = "Point"
       }
}

struct GeoPoint: Decodable {
    let pos: String
}
