//
//  CreatingCardViewController.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import SnapKit
import UIKit

class CreatingCardViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Variables
    weak var delegate: CardsTableViewControllerDelegate?
    private var coordinates: (longitude: Double, latitude: Double)?

    // MARK: - GUI
    private lazy var backgroundImageView = BackgroundImageView()
    
    private lazy var cardImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.image = UIImage(systemName: "plus")
        view.contentMode = .center

        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.pickImage(gestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRecognizer)

        return view
    }()

    private lazy var nameTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.setCustomPlaceholder(NSLocalizedString("name text field placeholder", comment: ""))

        return field
    }()
    
    private lazy var phoneNumberTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.setCustomPlaceholder(NSLocalizedString("phone text field placeholder", comment: ""))
        
        return field
    }()

    private lazy var webSiteTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.setCustomPlaceholder(NSLocalizedString("webSiteTextField placeholder", comment: ""))

        return field
    }()

    private lazy var addressTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.setCustomPlaceholder(NSLocalizedString("address text field placeholder", comment: ""))

        return field
    }()

    private lazy var descriptionTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.setCustomPlaceholder(NSLocalizedString("description text field placeholder", comment: ""))

        return field
    }()

    private lazy var ratingView: RatingView = RatingView()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.saveCard),
                         for: .touchUpInside)

        return button
    }()

    private lazy var stackOfPhones: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.phoneNumberTextField])
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .vertical

        return stack
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.title = "Create new card"
        self.view.backgroundColor = .cyan

        self.view.addSubview(self.cardImageView)
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.stackOfPhones)
        self.view.addSubview(self.webSiteTextField)
        self.view.addSubview(self.addressTextField)
        self.view.addSubview(self.descriptionTextField)
        self.view.addSubview(self.ratingView)
        self.view.addSubview(self.saveButton)

        self.setupConstraints()
    }

    // MARK: - Constraints
    private func setupConstraints() {

        self.cardImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(UIScreen.main.bounds.width * 0.42)
        }

        self.nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.cardImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(60)
        }

        self.stackOfPhones.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameTextField.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(60)
        }

        self.webSiteTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneNumberTextField.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(60)
        }

        self.addressTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.webSiteTextField.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(60)
        }

        self.descriptionTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressTextField.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(60)
        }

        self.ratingView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionTextField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(120)
        }

        self.saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.ratingView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(60)
        }
    }
    
    // MARK: - Methods
    private func showWarningAlert(withMessage message: String) {
        let alert = UIAlertController()
        alert.title = NSLocalizedString("warning alert title", comment: "")
        alert.message = message
        let alertAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""),
                                        style: .cancel, handler: nil)
        alert.addAction(alertAction)
        alert.pruneNegativeWidthConstraints()
        self.present(alert, animated: true)
    }

    // MARK: - Actions
    @objc private func saveCard() {
        guard let text = nameTextField.text,
            !text.isEmpty else {
                self.showWarningAlert(
                    withMessage: NSLocalizedString("empty name message",
                                                   comment: ""))
                return
        }
        
        if let phoneText = phoneNumberTextField.text {
            guard phoneText.isPhoneNumber() else {
                self.showWarningAlert(
                    withMessage: NSLocalizedString("incorrect phone number",
                                                   comment: ""))
                return
            }
        }
        
        print(self.coordinates)
        
        var url: URL?
        if let stringURL = self.webSiteTextField.text {
            url = URL(string: stringURL)
        }

        var newCard = CardModel(
            cardImage: nil,
            name: text,
            phoneNumber: self.phoneNumberTextField.text,
            webSite: url,
            adress: self.addressTextField.text,
            latitude: self.coordinates?.latitude,
            longitude: self.coordinates?.longitude,
            description: self.descriptionTextField.text,
            cardID: UUID(),
            dateOfLastUsing: Date(),
            serviceEvaluationBySourceUser: nil,
            userServiceEvaluation: Double(self.ratingView.rating),
            averageServiceEvaluationInTheChain: Double(self.ratingView.rating))

        newCard.set(image: self.cardImageView.image)

        CoreDataManager.shared.saveNewCardToPersistantSrore(card: newCard)

        self.delegate?.updateModel(withCard: newCard)
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func pickImage(gestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let chooseFromLibraryAction = UIAlertAction(
            title: NSLocalizedString("Choose From Library",
                                     comment: ""), style: .default) { _ in
                                        self.showImagePicker(withSourceType: .photoLibrary)
        }
        alert.addAction(chooseFromLibraryAction)
        alert.pruneNegativeWidthConstraints()

        alert.popoverPresentationController?.sourceView = self.cardImageView
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreatingCardViewController: UIImagePickerControllerDelegate {
    func showImagePicker(withSourceType source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            self.dismiss(animated: true, completion: nil)
            return
        }

        self.cardImageView.image = image
        self.cardImageView.contentMode = .scaleToFill

        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - extension UITextFieldDelegate
extension CreatingCardViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.addressTextField,
            let text = self.addressTextField.text {
            self.getCoordinateFromYandexAPI(forAddress: text)
        }
    }
}

//MARK: - extension Yandex request
extension CreatingCardViewController {
    
    private func getCoordinateFromYandexAPI(forAddress address: String) {
        
        let params: [String: String] = ["geocode": address]
        
        YandexGeocoderNetworking.shared.requestAlamofire(
            parameters: params,
            okHandler: { [weak self] (model: YandexResponseModel) in
                var responseModel: [FeatureMember]? = []
                responseModel = model.response.geoObjectCollection.featureMember
                guard !(responseModel?.isEmpty ?? true),
                    let stringLocation = responseModel?[0].geoObject.point.pos else {
                        return
                }
                
                self?.coordinates = self?.transformToDoubleCoordinate(
                    fromString: stringLocation)
                
            }, errorHandler: { [weak self] (error: NetError) in
                self?.handleError(error: error)
        })
    }
    
    private func transformToDoubleCoordinate(
        fromString coordinates: String) -> (Double, Double)? {
        
        let stringCoordinates = coordinates.components(separatedBy: " ")
        let latitudeString = stringCoordinates[0]
        let longitudeString = stringCoordinates[1]
        
        guard let latitude = Double(latitudeString),
            let longitude = Double(longitudeString) else { return nil }
        
        return (longitude, latitude)
    }
    
    private func handleError(error: NetError) {
        let title = NSLocalizedString("warning alert title", comment: "")
        var message = NSLocalizedString(
            "an error occurred when trying to request coordinates",
            comment: "")
        
        switch error {
        case .incorrectUrl:
            message += NSLocalizedString("incorect URL", comment: "")
        case .networkError(let error):
            message += error.localizedDescription
        default: break
        }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

