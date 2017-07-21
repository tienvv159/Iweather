//
//  MapVC.swift
//  iweather
//
//  Created by Vu Van Tien on 7/21/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import GoogleMaps
class MapVC: UIViewController , GMSMapViewDelegate{

    @IBOutlet weak var mapV: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        handlingMap()
        mapV.delegate = self
    }

    func handlingMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 21.031895 , longitude:105.799338 , zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.camera = camera
        self.mapV = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = camera.target
        //marker.position = CLLocationCoordinate2D(latitude: 21.031895, longitude: 105.799338)
        //marker.title = "139 cau giay"
        marker.snippet = "139 cg Ha noi"
        marker.map = mapView
    }
}
