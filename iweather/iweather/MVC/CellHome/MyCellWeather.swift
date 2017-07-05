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
    
    @IBOutlet weak var imgCurrentLocation: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var imgCell: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model:IweatheModel, temp:String, row:Int) {
        self.lblCity.text = model.city
        self.lblCountry.text = model.country
        temp == "F" ? (self.lblTemperature.text = String(model.tempF)) : (self.lblTemperature.text = String(model.tempC))
        let text = model.lastBuildDate.description
        let arr = text.components(separatedBy: " ")
        self.lblTime.text = "\(arr[4]) \(arr[5])"
        self.imgCell.image = model.handlingItem()
        if row == 0{
            self.imgCurrentLocation.image = UIImage(named: "location.png")
        }else{
            self.imgCurrentLocation.image = UIImage()
        }
    }
}
