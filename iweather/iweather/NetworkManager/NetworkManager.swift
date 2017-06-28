//
//  NetworkManager.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Alamofire

class NetworkManager {
    static let share = NetworkManager()
    
    
    func callApi(_ api:String, myClosures:@escaping (IweatheModel?) -> Void) {
        Alamofire.request(api).responseJSON { (respon) in
            var JSON = respon.result.value as? [String : Any]

            if let JSONModel = JSON {
                let model = IweatheModel.init(dic: JSONModel)
                myClosures(model)
            }else{
                JSON = nil
            }
        }
    }
    
    func callApiSearch(_ api:String, complete:@escaping (SearchModel?) -> Void) {
        Alamofire.request(api).responseJSON { (respon) in
            var JSON = respon.result.value as? [String : Any]
            if let JSONModel = JSON {
                let model = SearchModel.init(dic: JSONModel)
                complete(model)
            }else{
                JSON = nil
            }
        }
    }
}
