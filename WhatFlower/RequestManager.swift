//
//  RequestManager.swift
//  WhatFlower
//
//  Created by Thiago Antonio Ramalho on 19/12/21.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol RequestDelegate {
    func success(description: String)
}

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
    
    var delegate: RequestDelegate?
    
    public func get(flowerName: String) {
        parameters["titles"] = flowerName
        
        AF.request(wikipediaURl, method: .get, parameters: parameters).responseString { response in
            
            switch response.result {
            
            case .success(_):
                let jsonResponse = JSON(response.data!)
                let pageId = jsonResponse["query"]["pageids"][0].stringValue
                let description = jsonResponse["query"]["pages"][pageId]["extract"].stringValue
                self.delegate?.success(description: description)
            case .failure(_):
                print("failure")
            }
        }
        
    }
}
