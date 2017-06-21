//
//  IweatheModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Realm
import RealmSwift


class IweatheModel: Object {
   // dynamic var keySearch = ""
    dynamic var Key = ""
    dynamic var city = ""
    dynamic var lat = ""
    dynamic var long = ""
    dynamic var idModel = ""
    dynamic var humidity = ""
    dynamic var sunrise = ""
    dynamic var sunset = ""
    dynamic var text = ""
    dynamic var chill = ""
    dynamic var direction = ""
    dynamic var speed = ""
    dynamic var tempF = 0
    dynamic var tempC = 0
    dynamic var lastBuildDate = ""
     var forecast = List<ForecastModel>()
    
    convenience init(dic:[String : Any]) {
        self.init()
        
        guard let query = dic["query"] as? [String : Any] else{
            return
        }
            let results = query["results"] as? [String : Any] ?? [:]
            let channel = results["channel"] as? [String : Any] ?? [:]
            let location = channel["location"] as? [String : Any] ?? [:]
            let wind = channel["wind"] as? [String : Any] ?? [:]
            let atmosphere = channel["atmosphere"] as? [String : Any] ?? [:]
            let astronomy = channel["astronomy"] as? [String : Any] ?? [:]
            let item = channel["item"] as? [String : Any] ?? [:]
            let condition = item["condition"] as? [String : Any] ?? [:]
            let forecast = item["forecast"] as? [[String : Any]]  ?? [[:]]
        
        
        
        self.lat = item["lat"] as? String ?? ""
        self.long = item["long"] as? String ?? ""
        self.Key = "\(lat)\(long)"
        self.humidity = atmosphere["humidity"] as? String ?? ""
        self.sunrise = astronomy["sunrise"] as? String ?? ""
        self.sunset = astronomy["sunset"] as? String ?? ""
        self.text = condition["text"] as? String ?? ""
        self.chill = wind["chill"] as? String ?? ""
        self.direction = wind["direction"] as? String ?? ""
        self.speed = wind["speed"] as? String ?? ""
        self.lastBuildDate = channel["lastBuildDate"] as? String ?? ""
        self.city = location["city"] as? String ?? ""
        if let tempFs = condition["temp"] as? String, let temf = Int(tempFs)  {
            self.tempF = temf
        }
        self.tempC = Int(Double(tempF - 32) / 1.8)
        
        let dateF = DateFormatter()
        dateF.dateFormat = "yyyyMMddhhmmssSSS"
        self.idModel = dateF.string(from: Date())
        
        for item in forecast {
            let forecastModel = ForecastModel(dic: item)
            self.forecast.append(forecastModel)
        }

        
    }
    
//    convenience required init() {
//        let formatF = DateFormatter()
//        formatF.dateFormat = "yyyyMMddhhmmssSSS"
//        self.idModel = formatF.string(from: Date())
//    }
    
    // không cho những thuộc tính trong return lưu vào realm
//    override static func ignoredProperties() -> [String]{
//        return ["query","results","channel","units","lastBuildDate","location","wind","atmosphere","astronomy","item","condition","tempF","tempC","forecast","descriptions"]
//    }
    
    override static func primaryKey() -> String?{
        return "Key"
    }
    
    
}
