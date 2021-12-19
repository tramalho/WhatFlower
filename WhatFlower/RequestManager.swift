//
//  RequestManager.swift
//  WhatFlower
//
//  Created by Thiago Antonio Ramalho on 19/12/21.
//

import Foundation
import Alamofire

class RequestManager {
    private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    private var parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts",
        "exintro" : "",
        "explaintext" : "",
        "titles" : "flowerName",
        "indexpageids" : "",
        "redirects" : "1",
        ]
    
    public func get(flowerName: String) {
        parameters["titles"] = flowerName
        
        AF.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            
            case .success(_):
                print(response.result)
            case .failure(_):
                print("failure")
            }
            
        }
        
    }
}
