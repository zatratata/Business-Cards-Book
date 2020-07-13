//
//  CardsTableViewController.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import SnapKit
import UIKit

protocol CardsTableViewControllerDelegate: class {
    func updateModel(withCard: CardModel)
}

class CardsTableViewController: UIViewController {
    
    lazy var selectedCardFrame: CGRect = CGRect()
    
    lazy var selectedCardImage: UIImageView = UIImageView()
    
    private let barTitle: String = "Card book"
    
    var cardsModel: [CardModel]?
    var filteredModel: [CardModel]?
    
    private lazy var searchLine: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .minimal
        search.searchTextField.backgroundColor = .lightGray
        search.delegate = self
        
        return search
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .black
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.register(PocketCell.self, forCellReuseIdentifier: PocketCell.reusableIdentifier)
        
        return table
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(self.appMovedToBackground),
            name: UIApplication.willResignActiveNotification, object: nil)
        
        self.filteredModel = self.cardsModel
        
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.searchLine)
        self.view.addSubview(self.tableView)
        
        self.setupConstraints()
        self.setupNavigationBar()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.searchLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(safeArea)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchLine.snp.bottom)
            make.left.right.bottom.equalTo(safeArea)
        }
    }
    
    // MARK: - Methods
    private func setupNavigationBar() {
        
        self.title = self.barTitle
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem:
            .add,
            target: self,
            action: #selector(pushCreatingCardViewController))
        
        self.navigationItem.leftBarButtonItem = .init(
            barButtonSystemItem: .bookmarks,
            target: self,
            action: #selector(self.setMoloauto))
    }
    
    @objc private func pushCreatingCardViewController() {
        let nextVC = CreatingCardViewController()
        nextVC.delegate = self
        
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .popover
        self.present(nextVC, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @objc private func appMovedToBackground() {
        CoreDataManager.shared.saveContext()
    }
}

// MARK: - Extension table view data source
extension CardsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfElementsInModel = self.filteredModel?.count else { return 5 }
        return numberOfElementsInModel > 5 ? numberOfElementsInModel : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PocketCell.reusableIdentifier,
                                                 for: indexPath) as? PocketCell
        guard let pocketCell = cell else { return UITableViewCell() }
        
        if indexPath.row < self.filteredModel?.count ?? 0 {
            let card = self.filteredModel?[indexPath.row].getImage() ?? UIImage()
            pocketCell.setCardView(withImage: card)
            return pocketCell
        } else {
            pocketCell.setCardView(withImage: UIImage())
            return pocketCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.6
    }
}

//MARK: - Extension + UITableViewDelegate
extension CardsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < self.filteredModel?.count ?? 0 {
            
            let nextViewController = PresentCardInformationVC()
            nextViewController.setModel(
                withCard: self.filteredModel?[indexPath.row])
            
            nextViewController.modalTransitionStyle = .coverVertical
            nextViewController.modalPresentationStyle = .popover
            self.navigationController?.present(nextViewController,
                                               animated: true,
                                               completion: nil)
        }
    }
}

//MARK: - Conform to TableViewControllerDelegate
extension CardsTableViewController: CardsTableViewControllerDelegate {
    func updateModel(withCard card: CardModel) {
        
        if self.cardsModel == nil {
            self.cardsModel = []
        }
        self.cardsModel?.insert(card, at: 0)
        self.filteredModel = self.cardsModel
        self.tableView.reloadData()
    }
}

//MARK: - Conform to UISearchBarDelegate
extension CardsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredModel = self.cardsModel
        } else {
            self.filteredModel = self.cardsModel?.filter {
                ($0.name.lowercased()).contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}

//MARK: Addition for presentation
extension CardsTableViewController {
    @objc private func setMoloauto() {

        var card: CardModel = CardModel(
            cardImage: nil,
            name: "Moloauto",
            phoneNumber: "+3759379992",
            webSite: URL(string: "moloauto.by"),
            adress: "Молодечно, ул. Будавников д. 15А",
            latitude: 26.851587,
            longitude: 54.296992,
            description: "Самые дешевые автозапчасти в городе",
            cardID: UUID(),
            dateOfLastUsing: Date(),
            serviceEvaluationBySourceUser: 5,
            userServiceEvaluation: 5,
            averageServiceEvaluationInTheChain: 5)
        
        card.set(image: UIImage(named: "cardImage"))
        
        self.cardsModel?.insert(card, at: 0)
        self.filteredModel = self.cardsModel
        self.tableView.reloadData()
    }
}
