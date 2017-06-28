//
//  SearchModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Realm
import RealmSwift

class SearchModel: Object {
    
    var datas = List<ResulfSearchModel>()

    
   convenience init?(dic:[String : Any]) {
    
     guard let data = dic["data"] as? [[String : Any]] else {
        return nil
     }
        self.init()
    
    for item in data {
        let dataModel = ResulfSearchModel(dic: item)
        datas.append(dataModel)
    }
    
    }
    
}


