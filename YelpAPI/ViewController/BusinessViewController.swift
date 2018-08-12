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
import MapViewPlus

class BusinessViewController: UIViewController {

    
    @IBOutlet weak var mapView: MapViewPlus!
    
    let locationManager = CLLocationManager()
    var currentLocaation : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCurrentLocation()
        mapView.delegate = self
        self.becomeFirstResponder()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        
        guard let coordinates = locationManager.location?.coordinate else { return }
        zoomToLastestLocation(with: coordinates)
        
        BusinessController.shared.searchOnYelp(with: coordinates) { (businesses) in
            DispatchQueue.main.async {
                guard let biz = businesses else { return }
    
                for business in biz {
                    self.testingAnnotations(biz: business)
                    print(business.image_url)
                }
            }
        }
    }
    
    func zoomToLastestLocation(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        mapView.setRegion(region, animated: true)
    }
    
    func beginLocationUpdates(locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    

    func testingAnnotations(biz: Business) {
        let business = Business(name: biz.name, image_url: biz.image_url, coordinates: biz.coordinates, location: biz.location)
        let annotation = AnnotationPlus(viewModel: business, coordinate: CLLocationCoordinate2DMake(biz.coordinates.latitude, biz.coordinates.longitude))
        var annotations: [AnnotationPlus] = []
        annotations.append(annotation)
        mapView.setup(withAnnotations: annotations)
    }
}

extension BusinessViewController: CLLocationManagerDelegate {
    
    //MARK: - Fetches Current location
    func fetchCurrentLocation() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if  status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        currentLocaation = latestLocation.coordinate
        
        if currentLocaation == nil {
            zoomToLastestLocation(with: latestLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}

extension BusinessViewController: MKMapViewDelegate, MapViewPlusDelegate {
    
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus) -> UIImage {
        return #imageLiteral(resourceName: "taco").withRenderingMode(.alwaysTemplate)
    }

    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus {
        let calloutView = Bundle.main.loadNibNamed("YourCalloutView", owner: nil, options: nil)!.first as! YourCalloutView
         return calloutView
    }
    
    
    

    
    
}

