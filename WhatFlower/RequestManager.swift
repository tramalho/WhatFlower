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
    func success(description: String, imageURL: String)
}

class RequestManager {
    private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    private var parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts|pageimages",
        "exintro" : "",
        "explaintext" : "",
        "titles" : "flowerName",
        "indexpageids" : "",
        "redirects" : "1",
        "pithumbsize": "500"
    ]
    
    var delegate: RequestDelegate?
    
    public func get(flowerName: String) {
        parameters["titles"] = flowerName
        
        AF.request(wikipediaURl, method: .get, parameters: parameters).responseString { response in
            
            switch response.result {
            case .success(_):
                let jsonResponse = JSON(response.data!)
                print(jsonResponse)
                let pageId = jsonResponse["query"]["pageids"][0].stringValue
                let description = jsonResponse["query"]["pages"][pageId]["extract"].stringValue
                let imageURL = jsonResponse["query"]["pages"][pageId]["thumbnail"]["source"].stringValue
                self.delegate?.success(description: description, imageURL: imageURL)
            case .failure(_):
                print("failure")
            }
        }
        
    }
}
