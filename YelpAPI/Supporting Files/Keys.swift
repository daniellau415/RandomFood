//
//  Keys.swift
//  YelpAPI
//
//  Created by Daniel Lau on 9/27/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import Foundation

func accessKey(keyname : String) -> String {
    
    let filePath = Bundle.main.path(forResource: "keys", ofType: "plist") ?? ""
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: keyname) as? String else { return ""}
    return value
}

