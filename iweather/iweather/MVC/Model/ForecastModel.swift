//
//  ForecastModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/20/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import RealmSwift
class ForecastModel: Object  {
    dynamic var code = ""
    dynamic var date = ""
    dynamic var day = ""
    dynamic var high = ""
    dynamic var low = ""
    dynamic var textStatus = ""
    
    convenience init(dic:[String : Any]){
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
        self.high = high
        self.low = low
        self.textStatus = textStatus
    }
}
