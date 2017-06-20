//
//  MyCellLast.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

protocol MyCellLastDelegate {
    func checkTapToAddLocation(check:Bool)
    func checkTapToChangerTemperature(check:Bool)
}

class MyCellLast: UITableViewCell {
    var delegate:MyCellLastDelegate! = nil
    
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblOC: UILabel!
    @IBOutlet weak var lblF: UILabel!
    @IBOutlet weak var lblOF: UILabel!
    
    var temperature = "F"
    
    
    @IBAction func AddLocation(_ sender: Any) {
        if delegate != nil {
            delegate.checkTapToAddLocation(check: true)
        }
    }
      
    @IBAction func changerValueCF(_ sender: Any) {
        if delegate != nil {
            delegate.checkTapToChangerTemperature(check: true)
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
    
}
