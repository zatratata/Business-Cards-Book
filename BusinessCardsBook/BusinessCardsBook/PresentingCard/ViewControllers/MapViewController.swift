//
//  MapViewController.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/10/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Variables
    private var place: (longitude: Double, latitude: Double) = (0, 0)
    private var cardName: String?
    private var address: String?
    
    private let identifireForReusableAnnotation = "PlaceAnnotation"
    
    //MARK: - GUI Variables
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Back to card", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self,
                         action: #selector(self.tapOnBackButton),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        
        return map
    }()
    
//MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.backButton)
        
        self.makeConstraints()
        self.showAddressOnMap()

    }
    
    //MARK: - Constraints
    private func makeConstraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.backButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(safeArea)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(30)
        }
    }
    
    //MARK: -Actions
    @objc private func tapOnBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods
    private func showAddressOnMap() {
        let place = CLLocationCoordinate2D(latitude: self.place.latitude,
                                           longitude: self.place.longitude)
        
        let commonDelta: CLLocationDegrees = 1 / 111 // 1/111 = 1 latitude km
        let span = MKCoordinateSpan(latitudeDelta: commonDelta, longitudeDelta: commonDelta)
        let region = MKCoordinateRegion(center: place, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation = Annotation(title: self.cardName,
                                    subtitle: self.address,
                                   coordinate: place)
        self.mapView.addAnnotation(annotation)
    }
    
    //MARK: - Setter
    func setVariables(cardName: String?, address: String?, coordinate: (Double, Double)) {
        self.cardName = cardName
        self.address = address
        self.place = coordinate
    }
}



extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else { return nil }
        
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: self.identifireForReusableAnnotation) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation,
                                          reuseIdentifier: self.identifireForReusableAnnotation)
            view.glyphText = annotation.title
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        return view
    }
}
