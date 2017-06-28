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
    
}
