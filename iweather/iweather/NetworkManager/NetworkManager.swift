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
    
    
    func callApi(api:String, myClosures:@escaping (IweatheModel?) -> Void) {
        
        Alamofire.request(api).responseJSON { (respon) in
            var JSON = respon.result.value as? [String : Any]

            if let JSONModel = JSON {
                let model = IweatheModel.init(dic: JSONModel)
                myClosures(model)
            }else{
                // failed
                JSON = nil
            }
        }
    }
}
