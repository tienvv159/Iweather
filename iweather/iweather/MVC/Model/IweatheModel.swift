//
//  IweatheModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class IweatheModel: NSObject {
    
    var query = [String : Any]()
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
    var forecast = [[String : Any]()]
    var descriptions = String()
    
    init(dic:[String : Any]) {
        guard let querys = dic["query"] as? [String : Any],
            let resultss = querys["results"] as? [String : Any],
            let channels = resultss["channel"] as? [String : Any],
            let unitss = channels["units"] as? [String : Any],
            let lastBuildDates = channels["lastBuildDate"] as? String,
            let locations = channels["location"] as? [String : Any],
            let winds = channels["wind"] as? [String : Any],
            let atmospheres = channels["atmosphere"] as? [String : Any],
            let astronomys = channels["astronomy"] as? [String : Any],
            let items = channels["item"] as? [String : Any],
            let conditions = items["condition"] as? [String : Any],
            let forecasts = items["forecast"] as? [[String : Any]],
            let descriptionss = items["description"] as? String
            
            
        else{
            return
        }
        
        query = querys
        results = resultss
        channel = channels
        units = unitss
        lastBuildDate = lastBuildDates
        location = locations
        wind = winds
        atmosphere = atmospheres
        astronomy = astronomys
        item = items
        condition = conditions
        forecast = forecasts
        descriptions = descriptionss
        
    }
    
    
    
    
}
