//
//  MyCellTemp10Day.swift
//  iweather
//
//  Created by Vu Van Tien on 6/23/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyCellTemp10Day: UITableViewCell {


    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblHight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(modelForcast:ForecastModel, temp:String, modelWeather:IweatheModel) {
        if temp == "F"{
            self.lblDay.text = modelForcast.day
            self.lblLow.text = String(modelForcast.lowF)
            self.lblHight.text = String(modelForcast.highF)
        }else if temp == "C"{
            self.lblDay.text = modelForcast.day
            self.lblLow.text = String(modelForcast.lowC)
            self.lblHight.text = String(modelForcast.highC)
        }
        let code = modelForcast.code
        self.img.image = modelWeather.handlingItem(code: code)

    }
    
}
