//
//  StatusWeather.swift
//  iweather
//
//  Created by Vu Van Tien on 7/6/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Foundation
import UIKit

class StatusWeather:UIViewController {
    
    func handlingItem(code:String? = nil) -> UIImage {
        switch code ?? "32" {
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
    
    func handlingColorCell(code: String) -> UIColor
    {
        var listColor = ["FAEBD7","00FFFF","0000FF","8A2BE2","A52A2A","DEB887","5F9EA0","7FFF00","D2691E","FF7F50","6495ED","DC143C","00FFFF","00008B","008B8B","B8860B","A9A9A9","006400","BDB76B","8B008B","556B2F","FF8C00","E9967A","8FBC8F","2F4F4F","00CED1","FF1493","696969","1E90FF","228B22","FFD700","DAA520","808080","ADFF2F","CD5C5C","4B0082","ADD8E6","F08080","E0FFFF","20B2AA","778899","800000","9370DB","191970","808000","FF4500","800080","0000FF"]
        let color = listColor[Int(code)!];
        return hexStringToUIColor(hex: color)
    }
}
