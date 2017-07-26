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
    let locationManager = CLLocationManager()
    var checkLocation:String = ""
    var define:Define = Define()
    var statusWeather:StatusWeather = StatusWeather()
    var isOnLocation:Bool = false
    var arrDelete:[Int] = []
    var index = 1
    var acti:NVActivityIndicatorView!
    var labelShowLastUpdate:UILabel!

    override func viewDidAppear(_ animated: Bool) {
        getDataFromRealm()
        getCurrentLocation()
        updateLast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.myTableView.allowsMultipleSelection = true

        if listModel.count <= 0{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEditing))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }

        
        acti = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2 - 25, y: self.view.frame.height/2, width: 50, height: 50), type: NVActivityIndicatorType.pacman, color: UIColor.black, padding: 0)
        self.view.addSubview(acti)
        
        labelShowLastUpdate = UILabel(frame: CGRect(x: 75, y: 0 , width: self.view.frame.width - 150, height: 40))
        navigationController?.navigationBar.addSubview(labelShowLastUpdate)
    }
    
    func btnEditing() {
        myTableView.setEditing(true, animated: true)
        myTableView.reloadData()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(btnCancel))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func btnCancel() {
        myTableView.isEditing = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEditing))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        arrDelete.removeAll()
        myTableView.reloadData()
    }
    
    func btnDelete() {
        do
        {
            let realm = try Realm()
            try! realm.write {
                for i in arrDelete{
                    realm.delete(listModel[i])
                }
                getDataFromRealm()
                arrDelete.removeAll()
                myTableView.isEditing = false
            }
        }catch{
            self.showAlert(titleAlert: "Notification", message: "Error delete data", titleAction: "OK")
        }
        if listModel.count <= 0{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }else{
        }
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
        acti.startAnimating()
        let loadGroup = DispatchGroup()
        for item in listModel{
            loadGroup.enter()
            self.getAPI(item.title, complete: {
                loadGroup.leave()
            })
        }
        loadGroup.notify(queue: DispatchQueue.main) {
            self.myTableView.reloadData()
            self.acti.stopAnimating()
        }
    }
    
    func registerCell()  {
        let nib1 = UINib(nibName: "CellLast", bundle: nil)
        myTableView.register(nib1, forCellReuseIdentifier: "CellLast")
        
        let nib2 = UINib(nibName: "CellWeather", bundle: nil)
        myTableView.register(nib2, forCellReuseIdentifier: "CellWeather")
    }
    
    func getAPI(_ location:String,complete:@escaping ()->()) {
        let apiString = define.APIWithName(location: location)
        NetworkManager.share.callApi(apiString) { model in
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset < 0{
            arrDelete.removeAll()
        }
        if currentOffset <= -80 {
            if myTableView.isEditing == false{
                reloadDataWhenRunApp()
                updateLast()
            }
        }
    }
    
    func updateLast() {
        labelShowLastUpdate.textColor = UIColor.white
        labelShowLastUpdate.numberOfLines = 2
        let formatF = DateFormatter()
        formatF.dateFormat = "HH:mm:ss"
        labelShowLastUpdate.textAlignment = .center
        let currentTime = formatF.string(from: Date())
        labelShowLastUpdate.text = "last update \(currentTime)"
    }
}


extension HomeVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader:UIView = UIView()
        viewHeader.backgroundColor = UIColor.clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == listModel.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellLast", for: indexPath) as! CellLast
            cell.delegate = self
            cell.setupCell(listModel: listModel, tableView: myTableView)            
            if listModel.count <= 10{
                cell.btnAddLocation.isEnabled = true
            }else{
                cell.btnAddLocation.isEnabled = false
                changeTintColor(img: cell.imgAddLocation, color: UIColor.gray)
            }
            if listModel.count <= 0 || myTableView.isEditing == true{
                cell.imgViewToMap.image = UIImage(named: "mapGray1.png")
                cell.btnViewToMap.isEnabled = false
            }else{
                cell.imgViewToMap.image = UIImage(named: "if_map.png")
                cell.btnViewToMap.isEnabled = true
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWeather", for: indexPath) as! CellWeather
            cell.setupCell(model: listModel[indexPath.section], temp: temperature, strings1: checkLocation, Strings2: "\(listModel[indexPath.section].city).\(listModel[indexPath.section].country)")
            
            if isOnLocation == true{
                if indexPath.section == 0{
                    cell.tintColor = UIColor.clear
                }else{
                    cell.tintColor = UIColor.blue
                }
            }else{
                cell.tintColor = UIColor.blue
            }
            return cell
        }
    }
}

extension HomeVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if self.myTableView.isEditing{
            if isOnLocation == true && indexPath.section == 0{
                return UITableViewCellEditingStyle.none
            }else{
                return UITableViewCellEditingStyle(rawValue: 3)!
            }
        }else{
            return UITableViewCellEditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if isOnLocation == true{
                if indexPath.section != 0{
                    arrDelete.append(indexPath.section)
                    if arrDelete.count >= 1{
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(btnDelete))
                        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                    }
                }else{
                    myTableView.allowsSelection = true
                }
            }else{
                arrDelete.append(indexPath.section)
                if arrDelete.count >= 1{
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(btnDelete))
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                }
            }
        }else{
            if indexPath.section != listModel.count {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
                vc.listModel = listModel
                vc.row = indexPath.section
                vc.checkTemp = temperature
                navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        for (index , i) in arrDelete.enumerated() {
            if i == indexPath.section{
                arrDelete.remove(at: index)
            }
        }
        if arrDelete.count == 0{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        }
    }
    
    // delete row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == listModel.count{
            return false
        }else{
            if myTableView.isEditing == true{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            }else{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(btnEditing))
                navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isOnLocation == true{
                if indexPath.section != 0 && indexPath.section != listModel.count{
                    do
                    {
                        let realm = try Realm()
                        try! realm.write {
                            realm.delete(listModel[indexPath.section])
                            getDataFromRealm()
                        }
                    }catch{
                        self.showAlert(titleAlert: "Notification", message: "Error delete data", titleAction: "OK")
                    }
                }
            }else{
                if indexPath.section != listModel.count{
                    do
                    {
                        let realm = try Realm()
                        try! realm.write {
                            realm.delete(listModel[indexPath.section])
                            getDataFromRealm()
                        }
                    }catch{
                        self.showAlert(titleAlert: "Notification", message: "Error delete data", titleAction: "OK")
                    }
                }
            }
            if listModel.count <= 0{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            }else{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEditing))
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
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
            self.getDataFromRealm()
        })
    }
    
    func checkTapToChangerTemperature(_ check: Bool) {
        if check == true {
            (temperature == "F") ? (temperature = "C") : (temperature = "F")
            myTableView.reloadData()
        }
    }
    
    func checkTapToAddLocation(_ check: Bool) {
        if check == true && myTableView.isEditing == false{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.delegate = self // set delegate cho SearchVC
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func checkTapToViewMap(_ check: Bool) {
        if check == true{
            labelShowLastUpdate.text = "weather map"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GooGleMapVC") as! GooGleMapVC
            vc.listModel = listModel
            vc.checkTemp = temperature
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



