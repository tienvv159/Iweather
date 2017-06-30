//
//  TempHoursModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/29/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Realm
import RealmSwift

class TempHoursModel: Object {
    var hours = ""
    var temp = ""
    var code = 0
    
    
    
    convenience init(dic:[String : Any]) {
        self.init()
        
        let hourss = dic["hours"] as? String ?? ""
        let temps = dic["temp"] as? UInt32 ?? 0
        let codes = dic["code"] as? Int ?? 0
        
        hours = hourss
        temp = String(temps)
        code = codes
    }
    
    convenience init(temp: String, code: Int, hours: String){
        self.init()
        self.hours = hours
        self.temp = temp 
        self.code = code
    }
    
    
    
}

