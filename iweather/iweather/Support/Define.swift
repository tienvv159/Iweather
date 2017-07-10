//
//  Define.swift
//  iweather
//
//  Created by Vu Van Tien on 7/6/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Foundation
class Define  {
    func APISearch(location:String) -> String {
        return "https://www.yahoo.com/news/_td/api/resource/WeatherSearch;text=\(location.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")?bkt=newsdmcntr&device=desktop&feature=cacheContentCanvas%2CvideoDocking%2CnewContentAttribution%2Clivecoverage%2Cfeaturebar%2CdeferModalCluster%2CspecRetry%2CnewLayout%2Csidepic%2CcanvassOffnet%2CntkFilmstrip%2CautoNotif&intl=us&lang=en-US&partner=none&prid=97v352hckf2mk&region=US&site=fp&tz=Asia%2F&ver=2.0.7450001&returnMeta=true"
    }
    
    func APIWithLatLong(latLong:String) -> String {
        return "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (select woeid from geo.places where text=\"\(latLong)\")&format=json".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func APIWithName(location:String) -> String {
        return "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(location.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
    }
}
