//
//  MyCellWeather.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyCellWeather: UITableViewCell {

    @IBOutlet weak var imgBackgroudCell: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var imgCurrentLocation: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    let statusWeather:StatusWeather = StatusWeather()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model:IweatheModel, temp:String, strings1:String, Strings2:String) {
        self.lblCity.text = model.city
        self.lblCountry.text = model.country
        temp == "F" ? (self.lblTemperature.text = String(model.tempF)) : (self.lblTemperature.text = String(model.tempC))
        let text = model.lastBuildDate.description
        let arr = text.components(separatedBy: " ")
        self.lblTime.text = "\(arr[4]) \(arr[5])"
        self.imgCell.image = statusWeather.handlingItem(code: model.code)
        if strings1 == Strings2{
            self.imgCurrentLocation.image = UIImage(named: "location")
            self.imgCurrentLocation.image = self.imgCurrentLocation.image?.withRenderingMode(.alwaysTemplate)
            self.imgCurrentLocation.tintColor = UIColor.black
        }else{
            self.imgCurrentLocation.image = UIImage()
        }
        self.imgCell.image = self.imgCell.image!.withRenderingMode(.alwaysTemplate)
        self.imgCell.tintColor = UIColor.black
    }
}
