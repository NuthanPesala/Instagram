//
//  LocationPickerViewController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 29/05/21.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {

    private let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private var coordinates: CLLocationCoordinate2D?
    
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    
    var isPickable: Bool = true
    init(coordinates: CLLocationCoordinate2D?) {
        super.init(nibName: nil, bundle: nil)
        self.coordinates = coordinates
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        if isPickable {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(didTapSend))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnMapView))
        tapGesture.numberOfTouchesRequired = 1
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(tapGesture)
        }else {
            guard let coordinates = coordinates else {
                return
            }
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            mapView.addAnnotation(pin)
        }
    }
    
    @objc func didTapSend() {
        guard let coordinates = coordinates else {
            return
        }
        completion?(coordinates)
        navigationController?.popViewController(animated: true)
    }
    
   
    @objc func didTapOnMapView(gesture: UITapGestureRecognizer) {
        let locationView = gesture.location(in: mapView)
        let coordinates = mapView.convert(locationView, toCoordinateFrom: mapView)
        self.coordinates = coordinates
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
    }
    
}
