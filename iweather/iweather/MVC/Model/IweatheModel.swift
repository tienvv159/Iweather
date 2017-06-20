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
    dynamic var keySearch = ""
    dynamic var idModel = ""
    dynamic var city = ""
    dynamic var humidity = ""
    dynamic var sunrise = ""
    dynamic var sunset = ""
    dynamic var textStatus = ""
    dynamic var chill = ""
    dynamic var direction = ""
    dynamic var speed = ""
    dynamic var tempF = 0
    dynamic var tempC = 0
    dynamic var forecast = [ForecastModel]()
    
    convenience init(dic:[String : Any]) {
        self.init()
        
        guard let query = dic["query"] as? [String : Any] else{
            return
        }
            let results = query["results"] as? [String : Any] ?? [:]
            let channel = results["channel"] as? [String : Any] ?? [:]
            let location = channel["location"] as? [String : Any] ?? [:]
        
            self.city = location["city"] as? String ?? ""

            let wind = channel["wind"] as? [String : Any] ?? [:]
            let atmosphere = channel["atmosphere"] as? [String : Any] ?? [:]
        
            let astronomy = channel["astronomy"] as? [String : Any] ?? [:]
            self.item = channel["item"] as? [String : Any] ?? [:]
            self.condition = item["condition"] as? [String : Any] ?? [:]
            if let tempFs = condition["temp"] as? String, let temf = Int(tempFs)  {
            self.tempF = temf
            }
            self.forecast = item["forecast"] as? [[String : Any]]  ?? [[:]]
            self.descriptions = item["description"] as? String ?? ""
            self.tempC = Int(Double(tempF - 32) / 1.8)
        
            let dateF = DateFormatter()
            dateF.dateFormat = "yyyyMMddhhmmssSSS"
            self.idModel = dateF.string(from: Date())
        
    }
    
//    convenience required init() {
//        let formatF = DateFormatter()
//        formatF.dateFormat = "yyyyMMddhhmmssSSS"
//        self.idModel = formatF.string(from: Date())
//    }
    
    // không cho những thuộc tính trong return lưu vào realm
    override static func ignoredProperties() -> [String]{
        return ["query","results","channel","units","lastBuildDate","location","wind","atmosphere","astronomy","item","condition","tempF","tempC","forecast","descriptions"]
    }
    
    override static func primaryKey() -> String?{
        return "idModel"
    }
    
    
}
