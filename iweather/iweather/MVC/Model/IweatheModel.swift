//
//  IweatheModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Realm
import RealmSwift

class IweatheModel: Object{
    dynamic var keySearch = ""
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
    dynamic var country = ""
    dynamic var region = ""
    dynamic var pressure = ""
    dynamic var visibility = ""
    dynamic var descriptions = ""
    dynamic var code = ""
     var forecast = List<ForecastModel>()
    
    convenience init?(dic:[String : Any]) {
        
        guard let query = dic["query"] as? [String : Any] else{
            return nil
        }
        guard let results = query["results"] as? [String : Any] else{
            return nil
        }
        
        self.init()

            let channel = results["channel"] as? [String : Any] ?? [:]
            let location = channel["location"] as? [String : Any] ?? [:]
            let wind = channel["wind"] as? [String : Any] ?? [:]
            let atmosphere = channel["atmosphere"] as? [String : Any] ?? [:]
            let astronomy = channel["astronomy"] as? [String : Any] ?? [:]
            let item = channel["item"] as? [String : Any] ?? [:]
            let condition = item["condition"] as? [String : Any] ?? [:]
            let forecast = item["forecast"] as? [[String : Any]]  ?? [[:]]
        
        self.code = condition["code"] as? String ?? ""
        self.pressure = atmosphere["visibility"] as? String ?? ""
        self.visibility = atmosphere["visibility"] as? String ?? ""
        self.country = location["country"] as? String ?? ""
        self.region = location["region"] as? String ?? ""
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
        self.descriptions = item["description"] as? String ?? ""
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
    
    func handlingItem(code:String) -> UIImage {
        
        switch code {
        case "0":
            return #imageLiteral(resourceName: "ic_storm")
        case "1", "2", "3", "4":
            return #imageLiteral(resourceName: "ic_cloudThunder")
        case "5", "6", "7", "18", "46":
            return #imageLiteral(resourceName: "ic_rainSnow")
        case "8", "9", "10":
            return #imageLiteral(resourceName: "ic_rainCloud")
        case "11", "12":
            return #imageLiteral(resourceName: "ic_shower")
        case "13", "14", "15":
            return #imageLiteral(resourceName: "ic_snowWind")
        case "16":
            return #imageLiteral(resourceName: "ic_snow")
        case "17":
            return #imageLiteral(resourceName: "ic_hail")
        case "19", "20", "21", "22", "23":
            return #imageLiteral(resourceName: "ic_windDustWaring")
        case "24":
            return #imageLiteral(resourceName: "ic_wind")
        case "25", "26", "44":
            return #imageLiteral(resourceName: "ic_cloud")
        case "27", "29":
            return #imageLiteral(resourceName: "ic_moonBigCloud")
        case "28", "30":
            return #imageLiteral(resourceName: "ic_sunBigCloud")
        case "31", "32", "36":
            return #imageLiteral(resourceName: "ic_sun")
        case "33", "34":
            return #imageLiteral(resourceName: "ic_roller")
        case "35":
            return #imageLiteral(resourceName: "ic_shootingStar")
        case "37", "38", "39", "45", "47":
            return #imageLiteral(resourceName: "ic_thunder")
        case "40":
            return #imageLiteral(resourceName: "ic_sunRainCloud")
        case "41", "42", "43":
            return #imageLiteral(resourceName: "ic_thunderSnow")
        case "48":
            return #imageLiteral(resourceName: "ic_sunset")
        case "49":
            return #imageLiteral(resourceName: "ic_sunrise")
        default:
            return #imageLiteral(resourceName: "ic_rainbow")
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
