//
//  HomeV.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.

import UIKit
import Alamofire
import RealmSwift
import SwiftGifOrigin
import CoreLocation

class HomeVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    var temperature:String = "F"
    var listModel:[IweatheModel] = []
    var listModelAffterSort:[IweatheModel] = []
    let locationManager = CLLocationManager()
    var checkLocation:String = ""
    var define:Define = Define()
    var statusWeather:StatusWeather = StatusWeather()
    var isOnLocation:Bool = false
    override func viewDidAppear(_ animated: Bool) {
        getDataFromRealm()
        getCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }

    func getDataCurrentLocation(latLong:String, complete: () -> ()) {
        let stringAPI = define.APIWithLatLong(latLong: latLong)
        NetworkManager.share.callApi(stringAPI) { (modelIweather) in
            if let model = modelIweather{
                self.checkLocation = "\(model.city).\(model.country)"
                do
                {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(model, update: true)
                    }
                }
                catch{
                    self.showAlert(titleAlert: "Notification", message: "error save realm", titleAction: "OK")
                }
            }else{
                self.showAlert(titleAlert: "Notification", message: "Network error. please try again", titleAction: "OK")
            }
            self.getDataFromRealm()
        }
    }
    
    func getDataFromRealm() {
        do{
            let realm = try Realm()
            // chả về 1 mảng các model đã lưu trong reaml
            let list = realm.objects(IweatheModel.self)
            listModel.removeAll()
            for model in list {
                listModel.append(model)
            }
            listModel = listModel.sorted(by: { o1,o2 in
                return checkLocation == (o1.city + "." + o1.country)
            })
            reloadDataWhenRunApp()
        }catch {
            self.showAlert(titleAlert: "Notification", message: "error get data from realm", titleAction: "OK")
        }
    }
    
    func reloadDataWhenRunApp() {
        let downloadGroup = DispatchGroup()
        for item in listModel{
            downloadGroup.enter()
            self.getAPI(item.title, complete: {
                downloadGroup.leave()
            })
        }
        downloadGroup.notify(queue: DispatchQueue.main) {
            self.myTableView.reloadData()
        }
    }
    
    func registerCell()  {
        let nib1 = UINib(nibName: "MyCellLast", bundle: nil)
        myTableView.register(nib1, forCellReuseIdentifier: "MyCellLast")
        
        let nib2 = UINib(nibName: "MyCellWeather", bundle: nil)
        myTableView.register(nib2, forCellReuseIdentifier: "MyCellWeather")
    }
    
    func checkTapToAddLocation(_ check: Bool) {
        if check == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.delegate = self // set delegate cho SearchVC
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func getAPI(_ location:String,complete:@escaping ()->()) {
        
        let apiString = define.APIWithName(location: location)
        //EZLoadingActivity.show("Loading", disableUI: true)
        NetworkManager.share.callApi(apiString) { model in
            //EZLoadingActivity.hide(true, animated: true)
            if let model = model{
                self.myTableView.reloadData()
                do
                {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(model, update: true)
                    }
                }
                catch{
                    self.showAlert(titleAlert: "Notification", message: "error save data", titleAction: "OK")
                }
            }else{
                self.showAlert(titleAlert: "Notification", message: "Network error. please try again", titleAction: "OK")
            }
            complete()
        }
    }
    
    func showAlert(titleAlert:String, message:String, titleAction:String) {
        let alert = UIAlertController(title: titleAlert, message: message, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: titleAction, style: .default) { (btnOK) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
}


extension HomeVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if indexPath.row == listModel.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellLast", for: indexPath) as! MyCellLast
            
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellWeather", for: indexPath) as! MyCellWeather
            cell.setupCell(model: listModel[indexPath.row], temp: temperature, strings1: checkLocation, Strings2: "\(listModel[indexPath.row].city).\(listModel[indexPath.row].country)")
//            cell.contentView.backgroundColor = statusWeather.handlingColorCell(code: listModel[indexPath.row].code)
       
        return cell
        }
    }
}

extension HomeVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != listModel.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
            vc.listModel = listModel
            vc.row = indexPath.row
            vc.checkTemp = temperature
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    // delete row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != 0 && indexPath.row != listModel.count{
            return true
        }else{
            return false
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row != 0 || indexPath.row == listModel.count{
                do
                {
                    let realm = try Realm()
                    
                    try! realm.write {
                        realm.delete(listModel[indexPath.row])
                        listModel.remove(at: indexPath.row)
                        myTableView.reloadData()
                    }
                }catch{
                    self.showAlert(titleAlert: "Notification", message: "Error delete data", titleAction: "OK")
                }
            }
        }
    }
}



extension HomeVC: CLLocationManagerDelegate{
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
        isOnLocation = true
        let defaults = UserDefaults.standard
        defaults.set(isOnLocation, forKey: "isOnLocation")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        locationManager.stopUpdatingLocation()
        let latLong = "\((locValue.latitude,locValue.longitude))"
        getDataCurrentLocation(latLong: latLong) {
            myTableView.reloadData()
        }
    }
}


extension HomeVC:  MyCellLastDelegate, SearchVCDelegate{
    func textSearch(_ text: String) {
        
        getAPI(text, complete: {
            self.myTableView.reloadData()
            self.getDataFromRealm()
        })
    }
    
    func checkTapToChangerTemperature(_ check: Bool) {
        if check == true {
            (temperature == "F") ? (temperature = "C") : (temperature = "F")
            myTableView.reloadData()
        }
    }
}



