//
//  InfoWeatherCell.swift
//  iweather
//
//  Created by Vu Van Tien on 6/23/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class InfoWeatherCell: UITableViewCell {

    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
   
    @IBOutlet weak var lblVisibility: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(modelIndexpath: IweatheModel) {
        self.lblSunrise.text = modelIndexpath.sunrise
        self.lblSunset.text = modelIndexpath.sunset
        self.lblPressure.text = "\(modelIndexpath.pressure) mb"
        self.lblVisibility.text = "\(modelIndexpath.visibility) km"
        self.lblHumidity.text = "\(modelIndexpath.humidity) %"

    }
    
}
