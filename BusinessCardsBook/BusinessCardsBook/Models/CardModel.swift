//
//  CardModel.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

struct CardModel: Codable {

    var cardImage: Data?

    var name: String
    var phoneNumber: String?
    var webSite: URL?
    var adress: String?
    var latitude: Double?
    var longitude: Double?
    var description: String?

    var cardID: UUID

    var dateOfLastUsing: Date

    var serviceEvaluationBySourceUser: Double?
    var userServiceEvaluation: Double?
    var averageServiceEvaluationInTheChain: Double?

    func getImage() -> UIImage? {
        if let data = self.cardImage {
            return UIImage(data: data)
        }
        return nil
    }

    mutating func set(image: UIImage?) {
        self.cardImage = image?.jpegData(compressionQuality: 0.5)
    }

    // MARK: - Import/export
    static func importData(from url: URL) {

        guard
            let data = try? Data(contentsOf: url),
            let card = try? JSONDecoder().decode(CardModel.self, from: data)
            else { return }

        CoreDataManager.shared.saveNewCardToPersistantSrore(card: card)

        try? FileManager.default.removeItem(at: url)
    }

    func exportToURL() -> URL? {
        guard let encoded = try? JSONEncoder().encode(self) else { return nil }

        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first

        guard let path = documents?.appendingPathComponent("/\(self.name).bcb") else {
            return nil
        }

        do {
            try encoded.write(to: path, options: .atomicWrite)
            return path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
