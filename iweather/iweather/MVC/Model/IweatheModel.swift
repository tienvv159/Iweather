//
//  IweatheModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class IweatheModel: NSObject {
    var idModel = ""
    var query: [String: Any] = [:]
    var results = [String : Any]()
    var channel = [String : Any]()
    var units = [String : Any]()
    var lastBuildDate = String()
    var location = [String : Any]()
    var wind = [String : Any]()
    var atmosphere = [String : Any]()
    var astronomy = [String : Any]()
    var item = [String : Any]()
    var condition = [String : Any]()
    var tempF = 0
    var tempC = 0
    var forecast = [[String : Any]()]
    var descriptions = ""
    
    init(dic:[String : Any]) {
        guard let query = dic["query"] as? [String : Any] else{
            return
        }
            self.results = query["results"] as? [String : Any] ?? [:]
            self.channel = results["channel"] as? [String : Any] ?? [:]
            self.units = channel["units"] as? [String : Any] ?? [:]
            self.lastBuildDate = channel["lastBuildDate"] as? String ?? ""
            self.location = channel["location"] as? [String : Any] ?? [:]
            self.wind = channel["wind"] as? [String : Any] ?? [:]
            self.atmosphere = channel["atmosphere"] as? [String : Any] ?? [:]
            self.astronomy = channel["astronomy"] as? [String : Any] ?? [:]
            self.item = channel["item"] as? [String : Any] ?? [:]
            self.condition = item["condition"] as? [String : Any] ?? [:]
            if let tempFs = condition["temp"] as? String, let temf = Int(tempFs)  {
            self.tempF = temf
            }
            self.forecast = item["forecast"] as? [[String : Any]]  ?? [[:]]
            self.descriptions = item["description"] as? String ?? ""
            self.tempC = Int(Double(tempF - 32) / 1.8)
        
            let formatF = DateFormatter()
            formatF.dateFormat = "yyyyMMddhhmmssSSS"
            self.idModel = formatF.string(from: Date())
   
    }
}
