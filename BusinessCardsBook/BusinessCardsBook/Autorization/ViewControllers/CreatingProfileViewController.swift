//
//  CreatingProfileViewController.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/9/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import SnapKit
import UIKit

class CreatingProfileViewController: UIViewController, UINavigationControllerDelegate {

    private let keyForUserDefault: String = "UserDataBusinessCardsBook2"
    private let barTitle: String = NSLocalizedString("bar title for creating profile VC", comment: "")
    private var model: ProfileModel?

    private var customAlert = CustomAlert()

    private var backgroundView: UIImageView = UIImageView()
    private var backgroundImage: UIImage? = UIImage(named: "leather")

    private lazy var userImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.image = UIImage(systemName: "camera")
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = UIScreen.main.bounds.width * 0.25
        view.clipsToBounds = true

        let gestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(self.pickImage(gestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRecognizer)

        return view
    }()

    private lazy var nameLabel: LabelForProfile = {
        let label = LabelForProfile()
        label.text = NSLocalizedString("name label text", comment: "")

        return label
    }()

    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.font = .boldSystemFont(ofSize: 22)
        field.placeholder = NSLocalizedString("placeholder for name textField", comment: "")
        field.textAlignment = .center
        field.borderStyle = .roundedRect

        return field
    }()

    private lazy var labelPhone: LabelForProfile = {
        let label = LabelForProfile()
        label.text = NSLocalizedString("phone label text", comment: "")

        return label
    }()

    private lazy var phoneTextField: UITextField = {
        let field = UITextField()
        field.font = .boldSystemFont(ofSize: 22)
        field.textAlignment = .center
        field.placeholder = NSLocalizedString("placeholder for phone and socialnetwork textFields",
                                              comment: "")
        field.borderStyle = .roundedRect

        return field
    }()

    private lazy var labelSocialID: LabelForProfile = {
        let label = LabelForProfile()
        label.text = NSLocalizedString("socialnetwork label text", comment: "")

        return label
    }()

    private lazy var socialNetworkTextField: UITextField = {
        let field = UITextField()
        field.font = .boldSystemFont(ofSize: 22)
        field.textAlignment = .center
        field.placeholder = NSLocalizedString("placeholder for phone and socialnetwork textFields",
                                              comment: "")
        field.borderStyle = .roundedRect

        return field
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle(NSLocalizedString("save button title", comment: ""), for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.prepareForSave),
                         for: .touchUpInside)

        return button
    }()

    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)

        return view
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBackground()

        self.view.addSubview(self.userImage)

        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.nameField)
        self.view.addSubview(self.labelPhone)
        self.view.addSubview(self.phoneTextField)
        self.view.addSubview(self.labelSocialID)
        self.view.addSubview(self.socialNetworkTextField)
        self.view.addSubview(self.saveButton)

        self.setupConstraints()
        self.setupNavigationBar()
        self.setupVisualEffect()
    }

    // MARK: - Constraints
    private func setupConstraints() {

        // saveButton
        self.saveButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(40)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }

        // socialNetworkTextField
        self.socialNetworkTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.saveButton.snp.top).offset(-20)
        }

        // labelSocialID
        self.labelSocialID.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.socialNetworkTextField.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }

        // phoneTextField
        self.phoneTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.labelSocialID.snp.top).offset(-10)
        }

        // labelPhone
        self.labelPhone.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.phoneTextField.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }

        // nameField
        self.nameField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.labelPhone.snp.top).offset(-10)
        }

        // nameLabel
        self.nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.nameField.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }

        // userImage
        self.userImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.nameLabel.snp.top).offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(self.view.snp.width).multipliedBy(0.5)
        }
    }

    // MARK: - Methods
    private func setupVisualEffect() {

        self.view.addSubview(self.visualEffectView)
        self.visualEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.visualEffectView.alpha = 0
    }

    private func setupNavigationBar() {

        self.title = self.barTitle
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    private func setupBackground() {

        self.view.addSubview(self.backgroundView)
        self.backgroundView.image = self.backgroundImage
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func saveProfileAndPushNewVC(_ isAllow: Bool, _ askEveryTime: Bool) {

        StartViewController.profile = ProfileModel(userImage: nil,
                                  name: self.nameField.text ?? "",
                                  userPhoneNumber: self.phoneTextField.text,
                                  userSocialNetworkID: self.socialNetworkTextField.text,
                                  isAllowToShareProfileData: isAllow,
                                  askPermissionEveryTime: askEveryTime)
        StartViewController.profile?.set(image: self.userImage.image)
        self.saveProfileToUserDefaults(profile: StartViewController.profile)
        let nextVC = CardsTableViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }

    private func saveProfileToUserDefaults(profile: ProfileModel?) {

        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: self.keyForUserDefault)
        }
    }

    // MARK: - Actions
    @objc private func prepareForSave() {
        //cheking name input
        guard let name = self.nameField.text, !name.isEmpty else {
            let alert = UIAlertController()
            alert.title = NSLocalizedString("warning alert title", comment: "")
            alert.message = NSLocalizedString("empty name message", comment: "")
            let alertAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                            style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)

            return
        }
        self.showCustomAlert()
    }

    private func showCustomAlert() {

        self.customAlert.tapAction = { [weak self] (permission, askEveryTime) in
            self?.saveProfileAndPushNewVC(permission, askEveryTime)
        }

        self.view.addSubview(self.customAlert)
        self.customAlert.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        self.customAlert.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.customAlert.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.customAlert.alpha = 1
            self.customAlert.transform = CGAffineTransform.identity
        }
    }

    // MARK: - Pick image
    @objc private func pickImage(gestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Cancel", comment: ""),
            style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(
                title: NSLocalizedString("Take Photo", comment: ""),
                style: .default) { _ in
                    self.showImagePicker(withSourceType: .camera)
            }
            alert.addAction(takePhotoAction)
        }

        let chooseFromLibraryAction = UIAlertAction(
            title: NSLocalizedString("Choose From Library", comment: ""),
            style: .default) { _ in
                self.showImagePicker(withSourceType: .photoLibrary)
        }
        alert.addAction(chooseFromLibraryAction)

        alert.popoverPresentationController?.sourceView = self.userImage
        present(alert, animated: true, completion: nil)
    }
}

    // MARK: - UIImagePickerControllerDelegate
    extension CreatingProfileViewController: UIImagePickerControllerDelegate {
      func showImagePicker(withSourceType source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
      }

      func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
          dismiss(animated: true, completion: nil)
          return
        }

        self.userImage.image = image
        self.userImage.contentMode = .scaleToFill

        dismiss(animated: true, completion: nil)
      }

      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
      }
}
