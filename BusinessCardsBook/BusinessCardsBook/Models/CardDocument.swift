//
//  CardDocument.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class CardDocument: UIDocument {

    var card: CardModel?
    var thumbnail: UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        return try JSONEncoder().encode(self.card)
    }
    
    override func load(fromContents contents: Any,
                       ofType typeName: String?) throws {
        if let card = contents as? Data {
            self.card = try JSONDecoder().decode(CardModel.self, from: card)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url,
                                                         for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] =
                [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey: thumbnail]
        }
        return attributes
    }
}
