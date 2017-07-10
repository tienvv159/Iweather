//
//  ForecastModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/20/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import RealmSwift
public class ForecastModel: Object  {
    //dynamic var key = ""
    dynamic var code = ""
    dynamic var date = ""
    dynamic var day = ""
    dynamic var highF = 0
    dynamic var lowF = 0
    dynamic var textStatus = ""
    dynamic var highC = 0
    dynamic var lowC = 0
    
    public convenience init(dic:[String : Any]){
        self.init()
        
        let code = 	dic["code"] as? String ?? ""
        let date = dic["date"] as? String ?? ""
        let day = dic["day"] as? String ?? ""
        let high = dic["high"] as? String ?? ""
        let low = dic["low"] as? String ?? ""
        let textStatus = dic["text"] as? String ?? ""
        
        
        self.code = code
        self.date = date
        self.day = day
        self.highF = Int(high) ?? 0
        self.lowF = Int(low) ?? 0
        self.textStatus = textStatus
        self.highC = Int(Double(highF - 32) / 1.8)
        self.lowC = Int(Double(lowF - 32) / 1.8)

    }
    
//    override static func primaryKey() -> String?{
//        return "Key"
//    }

}
