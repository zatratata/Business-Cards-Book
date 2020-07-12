//
//  StartViewController.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    static var profile: ProfileModel?
    
    private let keyForUserDefault: String = "UserDataBusinessCardsBook2"
    private let screenImage: UIImage? = UIImage(named: "StartScreen")
    
    private lazy var contentView: UIImageView = {
        let view = UIImageView()
        view.image = self.screenImage
 
        return view
    }()

    // MARK: - Life cycle
        override func viewDidLoad() {
            super.viewDidLoad()

            self.navigationController?.isNavigationBarHidden = true
            self.view.addSubview(self.contentView)

            self.setupConstraints()
            self.chooseNextViewController()
        }

        // MARK: - Constraints
        private func setupConstraints() {

            let safeArea = self.view.safeAreaLayoutGuide
            self.contentView.snp.makeConstraints { (make) in
                make.edges.equalTo(safeArea)
            }
        }

        // MARK: - Methods
        private func chooseNextViewController() {

            if let profile = self.readFromUserDefault() {
                StartViewController.profile = profile
                let nextViewController = CardsTableViewController()
                if let model = CoreDataManager.shared.loadDataToCardsArrayModel() {
                    nextViewController.cardsModel = model
                }
                    self.navigationController?.pushViewController(nextViewController,
                                            animated: true)
                } else {
                let nextViewController = CreatingProfileViewController()
                self.navigationController?.pushViewController(nextViewController,
                                        animated: true)
                }
        }

        private func readFromUserDefault() -> ProfileModel? {
            if let data = UserDefaults.standard
                .data(forKey: self.keyForUserDefault) {
                let profile = try? JSONDecoder().decode(ProfileModel.self, from: data)
                return profile
            }
            return nil
        }
    }

