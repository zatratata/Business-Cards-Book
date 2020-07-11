//
//  YandexGeocoderNetworking+ Ex.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/11/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import Foundation

extension YandexGeocoderNetworking {
    func getUrlWith(url: String, params: [String: String]? = nil) -> URL? {
        guard var components = URLComponents(string: url) else { return nil }
        if let params = params {
            components.queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
        }

        return components.url
    }
}
