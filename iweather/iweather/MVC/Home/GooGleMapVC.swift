//
//  GooGleMapVC.swift
//  iweather
//
//  Created by Vu Van Tien on 7/21/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GooGleMapVC: UIViewController ,GMSMapViewDelegate{
    var checkTemp:String?
    var listModel:[IweatheModel] = [IweatheModel]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 8.0
    
    var likelyPlaces: [GMSPlace] = []
    
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(btnBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        let camera = GMSCameraPosition.camera(withLatitude: 21.032018, longitude: 105.799209,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        for item in listModel{
            let markerView = ViewMarke(frame: CGRect(x: 0, y: 0, width: 45, height: 40 ))
            if checkTemp == "F"{
                markerView.lblTemp.text = String(item.tempF)
                markerView.lblValueTemp.text = "F"
            }else{
                markerView.lblTemp.text = String(item.tempC)
                markerView.lblValueTemp.text = "C"
            }
            markerView.imgStatus.image = StatusWeather.handlingItem(code: item.code)
            changeTintColor(img: markerView.imgStatus, color: UIColor.black)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(item.lat) ?? 0, longitude: Double(item.long) ?? 0)
            marker.title = item.city
            marker.snippet = item.country
            marker.map = mapView
            marker.icon = GMSMarker.markerImage(with: .black)
            marker.iconView = markerView
            view.addSubview(mapView)
        }
        mapView.delegate = self
        mapView.isHidden = true
    }
    
   
    func btnBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    func listLikelyPlaces() {
        likelyPlaces.removeAll()
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
}

extension GooGleMapVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
