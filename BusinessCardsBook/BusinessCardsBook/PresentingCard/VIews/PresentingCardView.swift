//
//  PresentingCardView.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/13/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit

class PresentingCardView: UIView {
    
    weak var delegate: PresentingCardDelegate?
    
    private lazy var backgroundImageView = BackgroundImageView()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.delegate = self

        return scroll
    }()

    lazy var cardImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.layer.shadowOffset = .init(width: 5, height: 3)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 5

        return view
    }()

    private lazy var nameLabel: ReusableLable = ReusableLable()

    private lazy var phoneNumberLabel: ReusableLable = {
        let label = ReusableLable()
        label.textColor = .systemBlue

        label.isUserInteractionEnabled = true
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.callNumber))
        label.addGestureRecognizer(gest)

        return label
    }()

    private lazy var webSiteLabel: ReusableLable = {
        let label = ReusableLable()
        label.textColor = .systemBlue

        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(self.openWebSite))
        label.addGestureRecognizer(gesture)

        return label
    }()

    private lazy var addressLabel: ReusableLable = {
        let label = ReusableLable()
        label.numberOfLines = 0

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
        button.setTitleColor(.systemIndigo, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.shareCard),
                         for: .touchUpInside)

        return button
    }()
    
    
    //MARK: -Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.backgroundImageView)
        self.backgroundImageView.contentMode = .scaleAspectFill

        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cardImageView)
        self.scrollView.addSubview(self.nameLabel)
        self.scrollView.addSubview(self.phoneNumberLabel)
        self.scrollView.addSubview(self.addressLabel)
        self.scrollView.addSubview(self.webSiteLabel)
        self.scrollView.addSubview(self.descriptionLabel)
        self.scrollView.addSubview(self.ratingFromPreviousUserView)
        self.scrollView.addSubview(self.shareButton)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    //MARK: - Methods
    func setValuesForGUI(image: UIImage?,
                         name: String,
                         phone: String?,
                         address: String?,
                         webSite: String?,
                         description: String?,
                         rating: Int) {

        self.cardImageView.image = image
        self.nameLabel.text = name
        self.phoneNumberLabel.text = phone
        self.addressLabel.text = address
        self.webSiteLabel.text = webSite
        self.descriptionLabel.text = description
        self.ratingFromPreviousUserView.rating = rating
    }
    
    func setUpAddressLabel() {
        
        self.addressLabel.textColor = .systemBlue
        self.addressLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(self.showAddressOnMap))
        self.addressLabel.addGestureRecognizer(gesture)
    }
    
    //MARK: -Actions
    @objc private func showAddressOnMap() {
        self.delegate?.showAddressOnMap()
    }
    
    @objc private func callNumber() {
        self.delegate?.callNumber()
    }
    
    @objc private func openWebSite() {
        self.delegate?.openWebSite()
    }
    
    @objc private func shareCard() {
        self.delegate?.shareCard()
    }
    
    //MARK: - Animations
    func animateSetCard() {

         let startOrigin = self.cardImageView.frame
        var rightPosition = self.cardImageView.frame
        rightPosition.origin.x += 250

        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseIn, animations: {
            self.cardImageView.frame = rightPosition
        }, completion: { _ in
            self.cardImageView.isHidden = false
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseOut, animations: {
                            self.cardImageView.frame = startOrigin
            })
        })
    }
}

// MARK: Extension + UIScrollViewDelegate
extension PresentingCardView: UIScrollViewDelegate {
    
}
