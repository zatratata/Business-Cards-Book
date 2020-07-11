//
//  CoreDataManager.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()
    static let entityName = "BusinessCards"

   private var currentContextData: [BusinessCards]?

    private let keyForSortDescriptor = "dateOfLastUsing"

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }

    func saveContext () {

        if self.context.hasChanges {
              do {
                try self.context.save()
              } catch {
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }

    private func readContext() {
        let request: NSFetchRequest<BusinessCards> = BusinessCards.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: self.keyForSortDescriptor, ascending: false)]
        do {
            self.currentContextData = try self.context.fetch(request)
        } catch let error as NSError {
            print("Coldn't read data. \(error), \(error.userInfo)")
        }

    }

    func loadDataToCardsArrayModel() -> [CardModel]? {

        var cardsArrayForModel: [CardModel] = []

        self.readContext()

        guard let contextData = self.currentContextData else { return nil }

        contextData.forEach {

            guard let name = $0.name,
                let cardID = $0.cardID,
                let dateOfLastUsing = $0.dateOfLastUsing else {
                    return
            }

            let card = CardModel(
                cardImage: $0.imageData,
                name: name,
                phoneNumber: $0.phoneNumber,
                webSite: $0.webSite,
                adress: $0.address,
                description: $0.serviceDescription,
                cardID: cardID,
                dateOfLastUsing: dateOfLastUsing,
                serviceEvaluationBySourceUser: $0.serviceEvaluationBySourceUser,
                userServiceEvaluation: $0.userServiceEvaluation,
                averageServiceEvaluationInTheChain: $0.averageServiceEvaluationInTheChain)

            cardsArrayForModel.append(card)

        }
        return cardsArrayForModel
    }

    func changeDateOfLastUsingInContextData(forCardId id: UUID, with date: Date) {
        self.currentContextData?.forEach {
            if let cardID = $0.cardID, cardID == id {
                $0.dateOfLastUsing = date
            }
        }
    }

    func saveNewCardToPersistantSrore(card: CardModel) {

        let newCard = BusinessCards(context: self.context)

        newCard.imageData = card.cardImage
        newCard.name = card.name
        newCard.phoneNumber = card.phoneNumber
        newCard.webSite = card.webSite
        newCard.address = card.adress
        newCard.latitude = card.latitude ?? 0.0
        newCard.longitude = card.longitude ?? 0.0
        newCard.cardID = card.cardID
        newCard.serviceDescription = card.description
        newCard.dateOfLastUsing = card.dateOfLastUsing
        newCard.userServiceEvaluation = card.userServiceEvaluation ?? 0.0
        newCard.averageServiceEvaluationInTheChain = card.averageServiceEvaluationInTheChain ?? 0.0

        self.saveContext()
    }
}
