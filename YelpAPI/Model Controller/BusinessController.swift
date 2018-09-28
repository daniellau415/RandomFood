//
//  BusinessController.swift
//  YelpAPI
//
//  Created by Daniel Lau on 8/5/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessController {
    
    static let shared = BusinessController()
    
    var businesses: [Business] = []
    
    let accessToken = accessKey(keyname: "token")
    
    func searchOnYelp(with location: CLLocationCoordinate2D, completion: @escaping([Business]?) -> Void)  {
        
        let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search?&latitude=\(location.latitude)&longitude=\(location.longitude)&term=taco&radius=1500&limit=7")
        
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let decodedData = try jsonDecoder.decode(Yelp.self, from: data)
                    let business = decodedData.businesses.compactMap({$0})
                    self.businesses = business
                    completion(business)
                } catch let error {
                    print("error decodiong data", error.localizedDescription)
                    completion(nil)
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    func stringToImage(with stringURL: String, completion: @escaping(UIImage?) -> Void) {
        guard let imageURL = URL(string: stringURL) else { return }
        let dataTask = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
        }
        dataTask.resume()
        
    }
}
