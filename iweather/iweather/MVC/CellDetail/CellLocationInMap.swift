//
//  CellLocationInMap.swift
//  iweather
//
//  Created by Vu Van Tien on 7/13/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
class CellLocationInMap: UITableViewCell {
    
    @IBOutlet weak var mapView: GMSMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

