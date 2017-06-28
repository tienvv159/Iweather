//
//  ResulfSearchModel.swift
//  iweather
//
//  Created by Vu Van Tien on 6/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Realm
import RealmSwift

class ResulfSearchModel: Object {

    dynamic var city = ""
    dynamic var country = ""
    dynamic var qualifiedName = ""
    
    convenience init(dic:[String : Any]){
        self.init()
        let citys = dic["city"] as? String ?? ""
        let countrys = dic["country"] as? String ?? ""
        let qualifiedNames = dic["qualifiedName"] as? String ?? ""
        
        city = citys
        country = countrys
        qualifiedName = qualifiedNames
    }

}
