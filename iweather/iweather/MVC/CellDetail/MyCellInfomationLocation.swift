//
//  MyCellInfomationLocation.swift
//  iweather
//
//  Created by Vu Van Tien on 6/23/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyCellInfomationLocation: UITableViewCell {
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblLat: UILabel!
    @IBOutlet weak var lblLong: UILabel!

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(modelIndexpath: IweatheModel) {
        self.lblCity.text = modelIndexpath.city
        self.lblLat.text = modelIndexpath.lat
        self.lblLong.text = modelIndexpath.long
        self.lblCountry.text = modelIndexpath.country
        self.lblRegion.text = modelIndexpath.region
    }
    
}
