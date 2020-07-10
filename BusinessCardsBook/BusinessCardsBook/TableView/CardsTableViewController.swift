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

    private let transitionManager = ModalyPresentationManager()

    lazy var selectedCardFrame: CGRect = CGRect()

    lazy var selectedCardImage: UIImageView = UIImageView()

    private let barTitle: String = "Card book"

    var cardsModel: [CardModel] = []
    var filteredModel: [CardModel] = []

    private lazy var searchLine: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .minimal
        search.searchTextField.backgroundColor = .lightGray
        search.delegate = self

        return search
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.register(PocketCell.self, forCellReuseIdentifier: PocketCell.reusableIdentifier)

        return table
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    @objc private func pushCreatingCardViewController() {
        let nextVC = CreatingCardViewController()
        nextVC.delegate = self

        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .popover
        self.present(nextVC, animated: true, completion: nil)
    }

}

// MARK: - Extension table view

extension CardsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PocketCell.reusableIdentifier,
                                                 for: indexPath) as? PocketCell
        guard let pocketCell = cell else { return UITableViewCell() }

        let card = self.filteredModel[indexPath.row].getImage() ?? UIImage()
        pocketCell.setCardView(withImage: card)

        return pocketCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.6
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let url =
//
//        self.selectedCardFrame = tableView.cellForRow(at: indexPath)?.frame ?? CGRect()
//        self.selectedCardFrame.origin.y += self.tableView.frame.origin.y
//        self.transitionManager.pocketFrame = self.selectedCardFrame
//
//        self.transitionManager.cardImage = (tableView.cellForRow(at: indexPath) as? PocketCell)?.cardView ?? UIImageView()
//        self.transitionManager.cardImage?.frame.origin.y += self.selectedCardFrame.origin.y
//
//        print("Pocket: \(self.transitionManager.pocketFrame), card: \(self.transitionManager.cardImage?.frame)")

        let nextViewController = PresentCardInformationVC()
        nextViewController.card = self.cardsModel[indexPath.row]

        nextViewController.modalTransitionStyle = .coverVertical
        nextViewController.modalPresentationStyle = .popover
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
//        self.present(nextViewController, animated: true, completion: nil)
//
//        nextViewController.transitioningDelegate = transitionManager
//        nextViewController.modalPresentationStyle = .custom
//        self.present(nextViewController, animated: true, completion: nil)
    }
}

extension CardsTableViewController: CardsTableViewControllerDelegate {
    func updateModel(withCard card: CardModel) {

        self.cardsModel.insert(card, at: 0)
        self.filteredModel = self.cardsModel
        self.tableView.reloadData()
    }
}

extension CardsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            self.filteredModel = self.cardsModel
        } else {
        self.filteredModel = self.cardsModel.filter {
            ($0.name.lowercased()).contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}
