//
//  Networking.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/11/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import Foundation
import Alamofire

enum NetError {
    case incorrectUrl
    case networkError(error: Error)
    case serverError(statusCode: Int)
    case parsingError(error: Error)
    case unknown
}

class YandexGeocoderNetworking {
    static let shared = YandexGeocoderNetworking()

    private let sessionManager: Alamofire.Session = Session.default

    private let baseURL: String = "https://geocode-maps.yandex.ru/1.x/"

    private let apiKey: String = "a6d2c6df-f14b-4548-a5f7-7c5cc6d0d581"
    private let responseFormat: String = "json"

    private lazy var parameters: [String: String] = [
        "apikey": self.apiKey,
        "format": self.responseFormat
    ]

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
    }

    func requestAlamofire<T: Decodable>(parameters: [String: String]? = nil,
                                        okHandler: @escaping (T) -> Void,
                                        errorHandler: @escaping (NetError) -> Void) {
        var urlParameters = self.parameters
        if let parameters = parameters {
            for paramater in parameters {
                urlParameters[paramater.key] = paramater.value
            }
        }

        guard let fullUrl = self.getUrlWith(url: self.baseURL,
                                            params: urlParameters) else {
            errorHandler(.incorrectUrl)
            return
        }

        self.sessionManager
            .request(fullUrl)
            .responseJSON { (response) in
                if let error = response.error {
                    errorHandler(.networkError(error: error))
                    return
                } else if let data = response.data,
                    let httpResponse = response.response {
                    switch httpResponse.statusCode {
                    case 200...300:
                        do {
                            let model = try JSONDecoder().decode(T.self, from: data)
                            okHandler(model)
                        } catch let error {
                            errorHandler(.parsingError(error: error))
                        }
                    case 401, 404:
                        break
                    default:
                        errorHandler(.serverError(statusCode: httpResponse.statusCode))
                    }
                } else {
                    errorHandler(.unknown)
                }
        }
    }
}
