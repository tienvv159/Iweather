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
}

class MyCellLast: UITableViewCell {
    var delegate:MyCellLastDelegate! = nil
    
    
    
    
    @IBAction func AddLocation(_ sender: Any) {
        if delegate != nil {
            delegate.checkTapToAddLocation(check: true)
        }
    }
      
    @IBAction func changerValueCF(_ sender: Any) {
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
