//
//  MyCellLast.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

protocol MyCellLastDelegate: class {
     func checkTapToAddLocation(_ check:Bool)
     func checkTapToChangerTemperature(_ check:Bool)
}

class CellLast: UITableViewCell {
    weak var delegate:MyCellLastDelegate?

    @IBOutlet weak var btnAddLocation: UIButton!
    @IBOutlet weak var imgAddLocation: UIImageView!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblOC: UILabel!
    @IBOutlet weak var lblF: UILabel!
    @IBOutlet weak var lblOF: UILabel!
    var temperature = "F"

    
    
    
    @IBAction func AddLocation(_ sender: Any) {
        delegate?.checkTapToAddLocation(true)
    }
      
    @IBAction func changerValueCF(_ sender: Any) {
        
//        if let homeVC = delegate as? HomeVC {
//            print(homeVC.temperature)
//        }
//        
            delegate?.checkTapToChangerTemperature(true)
            if temperature == "F" {
                lblF.textColor = UIColor.gray
                lblOF.textColor = UIColor.gray
                lblC.textColor = UIColor.white
                lblOC.textColor = UIColor.white
                temperature = "C"
            }else if temperature == "C" {
                lblF.textColor = UIColor.white
                lblOF.textColor = UIColor.white
                lblC.textColor = UIColor.gray
                lblOC.textColor = UIColor.gray
                temperature = "F"
        }
    }
}
