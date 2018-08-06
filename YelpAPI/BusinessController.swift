//
//  BusinessController.swift
//  YelpAPI
//
//  Created by Daniel Lau on 8/5/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import Foundation
import CoreLocation


class BusinessController {
    
    static let shared = BusinessController()
    
    var businesses: [Business] = []
    
     let accessToken = "JL4PMbUDUhx-pDdb07-lRsSAHCwoE_y8CKiK5G34kDMbd5pjX3hQXlerMrBkMEmj8gIO4p4F98h6SScNqmSsCcIN97RI7yjNEYI7JrpEex2NXOnSzALm1CbWfuHDWnYx"
    
    
    func searchOnYelp(with location: CLLocationCoordinate2D, completion: @escaping([Business]?) -> Void)  {
        
        let baseURL = URL(string: "https://api.yelp.com/v3/businesses/search?&latitude=\(location.latitude)&longitude=\(location.longitude)&categories=mexican&radius=3000&limit=5")
        
        print(baseURL)
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
}
