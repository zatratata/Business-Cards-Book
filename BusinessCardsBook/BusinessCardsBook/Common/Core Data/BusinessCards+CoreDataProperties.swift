//
//  BusinessCards+CoreDataProperties.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/11/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//
//

import Foundation
import CoreData


extension BusinessCards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessCards> {
        return NSFetchRequest<BusinessCards>(entityName: "BusinessCards")
    }

    @NSManaged public var address: String?
    @NSManaged public var averageServiceEvaluationInTheChain: Double
    @NSManaged public var cardID: UUID?
    @NSManaged public var dateOfLastUsing: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var serviceDescription: String?
    @NSManaged public var serviceEvaluationBySourceUser: Double
    @NSManaged public var userID: UUID?
    @NSManaged public var userServiceEvaluation: Double
    @NSManaged public var webSite: URL?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
