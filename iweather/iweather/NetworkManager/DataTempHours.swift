//
//  DataTempHours.swift
//  iweather
//
//  Created by Vu Van Tien on 6/30/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Foundation

class DataTempHours {
    
    
     static let arrHours = ["1AM", "2AM", "3AM", "4AM", "5AM","6AM", "7AM", "8AM", "9AM", "10AM", "11AM", "12AM", "1PM", "2PM", "3PM", "4PM", "5PM","6PM", "7PM", "8PM", "9PM", "10PM", "11PM", "12PM"]

    
    static func getData(temp:Int) -> [TempHoursModel] {
        var arrModel:[TempHoursModel] = []
        for i in 0..<24 {
            let dictionary:[String : Any] = ["hours" : arrHours[i], "temp" : randomTemp(temp: temp, index: i), "code" :randomCode()]
            let model = TempHoursModel.init(dic: dictionary)
            
            arrModel.append(model)
        }
        
        return arrModel
    }
    
    
    static func randomCode() -> Int {
        let rd = arc4random_uniform(7)
        if rd == 0 {
            return 10
        }else if rd == 1{
            return 24
        }else if rd == 2{
            return 25
        }else if rd == 3{
            return 27
        }else if rd == 4{
            return 28
        }else if rd == 5{
            return 31
        }else if rd == 6{
            return 37
        }else {
            return 40
        }
        
    }
      
    static func randomTemp(temp:Int, index:Int) -> UInt32 {
        if index < 6 || index >= 19 && index < 24{
            return arc4random_uniform(2) + UInt32(temp  - 4)
        }else if index >= 6 && index < 10 || index >= 15 && index < 19{
            return arc4random_uniform(2) + UInt32(temp - 2)
        }else if index >= 10 && index < 15{
            return arc4random_uniform(2) + UInt32(temp + 1)
        }
        return UInt32(temp)
    }
    
    func convertCF(temp:Int, tempF:Bool) -> Int {
        if tempF{
            return Int(Double(temp - 32) / 1.8)
        }else {
            return Int(Double(temp) * 1.8 + Double(32))
        }
    }

}
