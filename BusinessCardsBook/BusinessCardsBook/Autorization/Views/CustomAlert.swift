//
//  CustomAlert.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import SnapKit
import UIKit

class CustomAlert: UIView {

    var tapAction: ((Bool, Bool) -> Void)?

    private lazy var userInfoSwitch: UISwitch = UISwitch()
    private lazy var askUserInfoPermissionLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.text = NSLocalizedString("askUserInfoPermissionLabel text", comment: "")
        label.sizeToFit()

        return label
    }()

    private lazy var alwaysAskSwitch: UISwitch = UISwitch()
    private lazy var askAlwaysBeforeSharingLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.text = NSLocalizedString("askAlwaysBeforeSharingLabel text", comment: "")
        label.sizeToFit()

        return label
    }()

    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.setTitle(NSLocalizedString("Apply", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.apply),
                         for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.backgroundColor = .white

        self.addSubview(self.askUserInfoPermissionLabel)
        self.addSubview(self.userInfoSwitch)
        self.addSubview(self.askAlwaysBeforeSharingLabel)
        self.addSubview(self.alwaysAskSwitch)
        self.addSubview(self.applyButton)

        self.setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    private func setupConstraints() {
        self.askUserInfoPermissionLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(15)
        }

        self.userInfoSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(self.askUserInfoPermissionLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        self.askAlwaysBeforeSharingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userInfoSwitch.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
        }

        self.alwaysAskSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(self.askAlwaysBeforeSharingLabel.snp.bottom).offset(15)
            make.center.equalToSuperview()
        }

        self.applyButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.alwaysAskSwitch.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(80)
        }
    }

    @objc private func apply() {
        self.tapAction?(self.userInfoSwitch.isOn, self.alwaysAskSwitch.isOn)
    }
}
