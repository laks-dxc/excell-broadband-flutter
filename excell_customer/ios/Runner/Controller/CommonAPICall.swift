//
//  CommonAPICall.swift
//  WeatherInfo
//
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit
import CoreData

class CommonAPICall: NSObject {

    func getApiCall(url:String,completion:@escaping (_ result : Data)-> Void,failure:@escaping ((_ getError: Error) -> Void)) {
        guard let serviceUrl = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: serviceUrl) { (data, response, err) in
            
            guard let data = data else { return failure(err!) }
            print("response data \(data)")
            completion(data)
            
            }.resume()
    }
}
