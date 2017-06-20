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
}
