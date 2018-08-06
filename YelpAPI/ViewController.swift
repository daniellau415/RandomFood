//
//  ViewController.swift
//  YelpAPI
//
//  Created by Daniel Lau on 8/5/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let annotation = MKPointAnnotation()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        currentlocation()
        
        
     
        self.becomeFirstResponder()
    }


    
    @IBAction func buttonTapped(_ sender: Any) {
        
        guard let coordinates = locationManager.location?.coordinate else { return }
        BusinessController.shared.searchOnYelp(with: coordinates) { (businesses) in
            DispatchQueue.main.async {
                guard let biz = businesses else { return }
                print(biz)
    
                for business in biz {
                    let coordinate = business.coordinates
                    print(coordinate)
//                    self.annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//                    self.mapView.addAnnotation(self.annotation)

                }
            }
        }
        

    }
    


}

extension ViewController: CLLocationManagerDelegate {
    
    //MARK: - Fetches Current location
    func currentlocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        guard let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude else { return }
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
    }
}

