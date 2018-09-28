//
//  YourCalloutView.swift
//  YelpAPI
//
//  Created by Daniel Lau on 8/6/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import UIKit
import MapViewPlus
import MapKit

class YourCalloutView: UIView, CalloutViewPlus {
        
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    var coordinates : Coordinates?

    func configureCallout(_ viewModel: CalloutViewModel) {
        let viewModel = viewModel as! Business
        
        foodLabel.text = viewModel.name
        coordinates = viewModel.coordinates
        BusinessController.shared.stringToImage(with: viewModel.image_url, completion: { (image) in
            DispatchQueue.main.async {
                if let image = image {
    
                    self.foodImageView.image = image
                }
            }
        })
    }
    
    @IBAction func directionButtonTapped(_ sender: Any) {
        
        guard let lat = coordinates?.latitude, let long = coordinates?.longitude else { return }
        let location2D = CLLocationCoordinate2DMake(lat, long)
        
        let currentMapItem = MKMapItem.forCurrentLocation()
        
        let selectedMapPlacemark = MKPlacemark(coordinate: location2D, addressDictionary: nil)
        let selectedMapItem = MKMapItem(placemark: selectedMapPlacemark)
        
        print(currentMapItem, selectedMapItem)
        
        let mapItems = [currentMapItem, selectedMapItem]
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

        MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
        
    }
    
}
