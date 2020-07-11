//
//  PresentingCardInformationVC.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import SnapKit
import UIKit

class PresentCardInformationVC: UIViewController {

    var card: CardModel?

    // MARK: GUI
    private lazy var backgroundImageView = BackgroundImageView()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.delegate = self

        return scroll
    }()

    lazy var cardImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        view.layer.shadowOffset = .init(width: 5, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 5

        return view
    }()

    private lazy var nameLabel: ReusableLable = ReusableLable()

    private lazy var phoneNumberLabel: ReusableLable = {
        let label = ReusableLable()
        label.textColor = .blue

        label.isUserInteractionEnabled = true
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.callNumber))
        label.addGestureRecognizer(gest)

        return label
    }()

    private lazy var webSiteLabel: ReusableLable = {
        let label = ReusableLable()
        label.textColor = .blue

        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(self.openWebSite))
        label.addGestureRecognizer(gesture)

        return label
    }()

    private lazy var addressLabel: ReusableLable = {
        let label = ReusableLable()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(self.showAddressOnMap))
        label.addGestureRecognizer(gesture)

        return label
    }()

    private lazy var descriptionLabel: ReusableLable = {
        let label = ReusableLable()
        label.numberOfLines = 0

        return label
    }()

    private var ratingFromPreviousUserView: ShowRatingView = ShowRatingView()

    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle(NSLocalizedString("Share", comment: ""), for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.shareCard),
                         for: .touchUpInside)

        return button
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.contentMode = .scaleAspectFill

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cardImageView)
        self.scrollView.addSubview(self.nameLabel)
        self.scrollView.addSubview(self.phoneNumberLabel)
        self.scrollView.addSubview(self.addressLabel)
        self.scrollView.addSubview(self.webSiteLabel)
        self.scrollView.addSubview(self.descriptionLabel)
        self.scrollView.addSubview(self.ratingFromPreviousUserView)
        self.scrollView.addSubview(self.shareButton)

        self.setupConstraints()
        self.setValuesForGUI()
    }

    // MARK: - Constraints
    private func setupConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.cardImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(UIScreen.main.bounds.width * 0.42)
        }

        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.cardImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        self.phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        self.webSiteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneNumberLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        self.addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.webSiteLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }

        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }

        self.ratingFromPreviousUserView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(120)
        }

        self.shareButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.ratingFromPreviousUserView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    // MARK: - Methods
    private func setValuesForGUI() {
        guard let card = card else { return }
        //Change a date of last using for current card
        CoreDataManager.shared.changeDateOfLastUsingInContextData(forCardId: card.cardID, with: Date())

        self.cardImageView.image = self.card?.getImage()
        self.nameLabel.text = card.name
        self.phoneNumberLabel.text = card.phoneNumber
        self.addressLabel.text = card.adress
        self.webSiteLabel.text = card.webSite?.absoluteString
        self.descriptionLabel.text = card.description
        self.ratingFromPreviousUserView.rating = Int(card.userServiceEvaluation ?? 0)
    }

    // MARK: - Actions
    @objc private func showAddressOnMap() {
        let nextVC = MapViewController()
        nextVC.place = (27.333632, 53.938691)
        nextVC.cardName = self.card?.name
        nextVC.address = self.card?.adress
        self.navigationController?.modalPresentationStyle = .popover
        self.navigationController?.modalTransitionStyle = .coverVertical
        self.navigationController?.present(nextVC,
                                           animated: true,
                                           completion: nil)
    }
    
    @objc private func callNumber() {

        guard let number = self.phoneNumberLabel.text,
            let url = URL(string: "telprompt://\(number)") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
    }

    @objc private func openWebSite() {

        guard let siteString = self.webSiteLabel.text else { return }
        let url = URL(string: "http://" + siteString)
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc private func shareCard() {

        guard let card = self.card,
            let url = card.exportToURL() else { return }

        let activity = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        self.present(activity, animated: true, completion: nil)
    }
}

// MARK: - extension ScrolViewDelegate
extension PresentCardInformationVC: UIScrollViewDelegate {

}
