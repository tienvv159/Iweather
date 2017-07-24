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
    func checkTapToViewMap(_ check:Bool)
}

class CellLast: UITableViewCell {
    weak var delegate:MyCellLastDelegate?

    @IBOutlet weak var btnChangeTemp: UIButton!
    @IBOutlet weak var imgViewToMap: UIImageView!
    @IBOutlet weak var btnViewToMap: UIButton!
    @IBOutlet weak var btnAddLocation: UIButton!
    @IBOutlet weak var imgAddLocation: UIImageView!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var lblOC: UILabel!
    @IBOutlet weak var lblF: UILabel!
    @IBOutlet weak var lblOF: UILabel!
    var temperature = "F"
    
    @IBAction func viewToMap(_ sender: Any) {
        delegate?.checkTapToViewMap(true)
    }
    @IBAction func AddLocation(_ sender: Any) {
        delegate?.checkTapToAddLocation(true)
    }
    @IBAction func changerValueCF(_ sender: Any) {
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
    
    func setupCell(listModel:[IweatheModel], tableView:UITableView) {
        changeTintColor(img: self.imgAddLocation, color: UIColor.white)
//        if listModel.count <= 10{
//            self.btnAddLocation.isEnabled = true
//        }else{
//            self.btnAddLocation.isEnabled = false
//            changeTintColor(img: self.imgAddLocation, color: UIColor.gray)
//        }
        
        if tableView.isEditing == true{
            self.btnAddLocation.isEnabled = false
            changeTintColor(img: self.imgAddLocation, color: UIColor.gray)
            
            self.btnChangeTemp.isEnabled = false
            self.lblC.textColor = UIColor.gray
            self.lblOC.textColor = UIColor.gray
            self.lblF.textColor = UIColor.gray
            self.lblOF.textColor = UIColor.gray
            
            self.btnViewToMap.isEnabled = false
            self.imgViewToMap.image = UIImage(named: "mapGray1.png")
        }else{
            self.btnAddLocation.isEnabled = true
            changeTintColor(img: self.imgAddLocation, color: UIColor.white)
            
            self.btnChangeTemp.isEnabled = true
            if temperature == "F"{
                self.lblC.textColor = UIColor.gray
                self.lblOC.textColor = UIColor.gray
                self.lblF.textColor = UIColor.white
                self.lblOF.textColor = UIColor.white
            }else{
                self.lblC.textColor = UIColor.white
                self.lblOC.textColor = UIColor.white
                self.lblF.textColor = UIColor.gray
                self.lblOF.textColor = UIColor.gray
            }
            self.btnViewToMap.isEnabled = true
            self.imgViewToMap.image = UIImage(named: "if_map.png")
        }
    }
}
