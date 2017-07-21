//
//  TodayViewController.swift
//  myWeather
//
//  Created by Vu Van Tien on 7/5/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import CoreLocation
import RealmSwift


class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTempF: UILabel!
    @IBOutlet weak var lblTempC: UILabel!
    @IBOutlet weak var lblDegreesF: UILabel!
    @IBOutlet weak var lblDegreesC: UILabel!
    let locationManager = CLLocationManager()
    var timer:Timer = Timer()
    var modelWithLocation:IweatheModel?
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width:self.view.frame.size.width,height:120)
        getCurrentLocation()
    }
    
    
    @IBAction func gotoApp(_ sender: Any) {
        let myAppUrl = NSURL(string: "gotoApp://")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func getData(api:String, complete:@escaping ()->()) {
        let stringApi = "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (select woeid from geo.places where text=\"\(api)\")&format=json".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        callApiAndWriteDataToView(stringApi) {
        }
        complete()
        }
    
    func callApiAndWriteDataToView(_ api:String, complete:@escaping () -> ()) {
        NetworkManager.share.callApi(api) { (modelJSON) in
            if let model = modelJSON{
                self.lblCity.text = model.city
                self.lblTempC.text = String(model.tempC)
                self.lblTempF.text = String(model.tempF)
                self.lblStatus.text = model.text
                self.lblDegreesC.text = "o"
                self.lblDegreesF.text = "o"
            }
        }
    }
}
    


extension TodayViewController: CLLocationManagerDelegate{
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("-----------No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("-----------Access")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locationManager.stopUpdatingLocation()
        let latLong = "\((locValue.latitude,locValue.longitude))"
        
        getData(api: latLong) {
            
        }
    }
}

