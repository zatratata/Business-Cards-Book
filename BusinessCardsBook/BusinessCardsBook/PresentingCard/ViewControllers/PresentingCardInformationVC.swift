//
//  PresentingCardInformationVC.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import SnapKit
import UIKit

protocol PresentingCardDelegate: class {
    
    func showAddressOnMap()
    func callNumber()
    func openWebSite()
    func shareCard()
    
}

class PresentCardInformationVC: UIViewController {
    
    private var card: CardModel?
    private var appearsCounter: Int = 0
    
    // MARK: GUI
    
    private lazy var mainView: PresentingCardView = {
        let view = PresentingCardView()
        view.delegate = self
        
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.mainView)
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.setValuesForGUI()
        self.setUpAddressLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.appearsCounter == 0 {
            self.mainView.animateSetCard()
        }
        self.appearsCounter += 1
    }
    
    // MARK: - Methods
    func setModel(withCard card: CardModel?) {
        self.card = card
        self.appearsCounter = 0
    }
    
    private func setUpAddressLabel() {
        
        guard let longitude = self.card?.longitude,
            let latitude = self.card?.latitude,
            longitude != 0,
            latitude != 0 else {
                return
        }
        
        self.mainView.setUpAddressLabel()
    }
    
    private func setValuesForGUI() {
        guard let card = card else { return }
        
        //Change a date of last using for current card
        CoreDataManager.shared.changeDateOfLastUsingInContextData(forCardId: card.cardID, with: Date())
        
        self.mainView.setValuesForGUI(image: self.card?.getImage(),
                                      name: card.name,
                                      phone: card.phoneNumber,
                                      address: card.adress,
                                      webSite: card.webSite?.absoluteString,
                                      description: card.description,
                                      rating: Int(card.userServiceEvaluation ?? 0))
    }
}

//MARK: - Extension + PresentCardDelegate
extension PresentCardInformationVC: PresentingCardDelegate {
    
    func showAddressOnMap() {
           let nextVC = MapViewController()
           
           guard let longitude = self.card?.longitude,
               let latitude = self.card?.latitude else {
                   return
           }
           
           nextVC.setVariables(cardName: self.card?.name,
                               address: self.card?.adress,
                               coordinate: (latitude, longitude))
           self.modalPresentationStyle = .popover
           self.modalTransitionStyle = .coverVertical
           self.present(nextVC, animated: true, completion: nil)
       }
    
    func callNumber() {
        
        guard let number = self.card?.phoneNumber,
            let url = URL(string: "telprompt://\(number)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
    }
    
    func openWebSite() {
        
        guard let siteString = self.card?.webSite?.absoluteString else { return }
        let url = URL(string: "http://" + siteString)
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func shareCard() {
        
        guard let card = self.card,
            let url = card.exportToURL() else { return }
        
        let activity = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        self.present(activity, animated: true, completion: nil)
    }
}

