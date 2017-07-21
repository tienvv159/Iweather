//
//  GooGleMapVC.swift
//  iweather
//
//  Created by Vu Van Tien on 7/21/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import GoogleMaps
class GooGleMapVC: UIViewController {

    @IBOutlet weak var ViewGoogleMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 21.032018, longitude: 105.799209, zoom: 10.0)
        ViewGoogleMap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = self.ViewGoogleMap
    }
}
