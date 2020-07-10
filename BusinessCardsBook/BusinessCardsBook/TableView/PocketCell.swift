//
//  PocketCell.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import SnapKit
import UIKit

class PocketCell: UITableViewCell {

    private lazy var rightPosition: CGRect = {
        var frame = self.cardView.frame
        frame.origin.x += 100

        return frame
    }()

    static let reusableIdentifier = "pocketWithBusinessCard"

    private let imageNameForBackground = "leather"
    private let imageNameForPocketView = "coverImage"

    lazy var cardView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var verticalString: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "verticalString")

        return view
    }()

    private lazy var horizontalString: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "horizontalString")

        return view
    }()

    private lazy var pocketView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: self.imageNameForPocketView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var shortString: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "shortHorizontaly")

        return view
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: PocketCell.reusableIdentifier)

        self.backgroundView = UIImageView(
            image: UIImage(named: self.imageNameForBackground))

        self.selectionStyle = .none
        self.contentView.addSubview(self.cardView)
        self.contentView.addSubview(self.pocketView)
        self.pocketView.addSubview(self.verticalString)
        self.pocketView.addSubview(self.shortString)
        self.contentView.addSubview(self.horizontalString)

        self.setupConstraints()

        //
        self.pocketView.layer.shadowColor = UIColor.black.cgColor
        self.pocketView.layer.shadowOffset = .init(width: 10, height: 0)
        self.pocketView.layer.shadowOpacity = 5

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: Constraints
    private func setupConstraints() {
        
        //pocketView
        self.pocketView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        //cardView
        self.cardView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(self.pocketView.snp.height).multipliedBy(0.7)
        }

        self.verticalString.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }

        self.horizontalString.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(self.pocketView.snp.right)
        }

        self.shortString.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
    }

        // MARK: - Methods
    func setCardView(withImage card: UIImage) {
        self.cardView.image = card
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let startOrigin = self.cardView.frame

        if selected {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.cardView.frame = self.rightPosition
            }, completion: { _ in
                 self.contentView.bringSubviewToFront(self.cardView)
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.cardView.frame = startOrigin
                }, completion: { (_) in
                    self.contentView.bringSubviewToFront(self.pocketView)
                })
            })
        } else {
                 self.contentView.bringSubviewToFront(self.pocketView)
        }
    }
}
