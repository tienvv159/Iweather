//
//  MyCellWeather.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyCellWeather: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblTemperature: UILabel!
    
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var imgCell: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
