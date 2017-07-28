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
    var viewContentActi:UIView? = nil

    override func viewDidAppear(_ animated: Bool) {
        getDataFromRealm()
        getCurrentLocation()
        updateLast()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        registerCell()
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.myTableView.allowsMultipleSelection = true
        
        acti = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2 - 25, y: self.view.frame.height/2, width: 50, height: 50), type: NVActivityIndicatorType.pacman, color: UIColor.black, padding: 0)
        viewContentActi = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewContentActi?.isHidden = true
        viewContentActi?.backgroundColor = UIColor.clear
        viewContentActi?.addSubview(acti)
        self.view.addSubview(viewContentActi!)
        
        labelShowLastUpdate = UILabel(frame: CGRect(x: 75, y: 0 , width: self.view.frame.width - 150, height: 40))
        navigationController?.navigationBar.addSubview(labelShowLastUpdate)
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
            if listModel.count <= 0{
                hiddenRightBarbutton()
            }else{
                showRightBarButtonEdit()
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
        let loadGroup = DispatchGroup()
        for item in listModel{
            loadGroup.enter()
            self.getAPI(item.title, complete: {
                loadGroup.leave()
            })
        }
        loadGroup.notify(queue: DispatchQueue.main) {
            self.myTableView.reloadData()
        }
    }
    
    func registerCell()  {
        let nib1 = UINib(nibName: "CellLast", bundle: nil)
        myTableView.register(nib1, forCellReuseIdentifier: "CellLast")
        
        let nib2 = UINib(nibName: "CellWeather", bundle: nil)
        myTableView.register(nib2, forCellReuseIdentifier: "CellWeather")
    }
    
    func getAPI(_ location:String,complete:@escaping ()->()) {
        acti.startAnimating()
        viewContentActi?.isHidden = false
        let apiString = define.APIWithName(location: location)
        NetworkManager.share.callApi(apiString) { model in
            self.viewContentActi?.isHidden = true
            self.acti.stopAnimating()
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
        if currentOffset <= -80 && Reachability.isConnectedToNetwork(){
            if myTableView.isEditing == false{
                reloadDataWhenRunApp()
                updateLast()
            }
        }else if currentOffset <= -80 && !Reachability.isConnectedToNetwork(){
            let alert = UIAlertController(title: "", message: "Internet Not Connection Available! \n Please Connection Internet \n And Try Again!!", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(btnOK)
            present(alert, animated: true, completion: nil)
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
                
                cell.btnChangeTemp.isEnabled = false
                cell.lblC.textColor = UIColor.gray
                cell.lblF.textColor = UIColor.gray
                cell.lblOC.textColor = UIColor.gray
                cell.lblOF.textColor = UIColor.gray
            }else{
                cell.imgViewToMap.image = UIImage(named: "if_map.png")
                cell.btnViewToMap.isEnabled = true
                
                cell.btnChangeTemp.isEnabled = true
                if temperature == "F"{
                    cell.lblC.textColor = UIColor.gray
                    cell.lblF.textColor = UIColor.white
                    cell.lblOC.textColor = UIColor.gray
                    cell.lblOF.textColor = UIColor.white
                }else{
                    cell.lblC.textColor = UIColor.white
                    cell.lblF.textColor = UIColor.gray
                    cell.lblOC.textColor = UIColor.white
                    cell.lblOF.textColor = UIColor.gray
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWeather", for: indexPath) as! CellWeather
            cell.setupCell(model: listModel[indexPath.section], temp: temperature, strings1: checkLocation, Strings2: "\(listModel[indexPath.section].city).\(listModel[indexPath.section].country)")
            
            if isOnLocation == true{
                if indexPath.section == 0 && Reachability.isConnectedToNetwork(){
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
            if isOnLocation == true && indexPath.section == 0 && Reachability.isConnectedToNetwork(){
                return UITableViewCellEditingStyle.none
            }else{
                return UITableViewCellEditingStyle(rawValue: 3)!
            }
        }else{
            if isOnLocation == true && indexPath.section == 0 && Reachability.isConnectedToNetwork(){
                return UITableViewCellEditingStyle.none
            }else{
                return UITableViewCellEditingStyle.delete
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if isOnLocation == true{
                if Reachability.isConnectedToNetwork(){
                    if indexPath.section != 0 {
                        arrDelete.append(indexPath.section)
                        if arrDelete.count >= 1{
                            showRightBarButtonDelete()
                        }
                    }
                }else{
                    arrDelete.append(indexPath.section)
                    if arrDelete.count >= 1{
                        showRightBarButtonDelete()
                    }
                }
            }else{
                arrDelete.append(indexPath.section)
                if arrDelete.count >= 1{
                    showRightBarButtonDelete()
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
        if arrDelete.count <= 0{
            hiddenRightBarbutton()
        }else{
            showRightBarButtonDelete()
        }
    }
    
    // delete row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == listModel.count{
            return false
        }else{
            return true
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if Reachability.isConnectedToNetwork(){
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
                                if listModel.count >= 1{
                                    getDataFromRealm()
                                }
                            }
                        }catch{
                            self.showAlert(titleAlert: "Notification", message: "Error delete data", titleAction: "OK")
                        }
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
                hiddenRightBarbutton()
            }else{
                showRightBarButtonEdit()
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
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}


extension HomeVC{
    func showRightBarButtonEdit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(btnEditing))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    func showRightBarButtonDelete() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(btnDelete))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    func hiddenRightBarbutton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    func showleftBarButtonCancel() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(btnCancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    func hiddenLeftBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}

extension HomeVC{
    func btnEditing() {
        myTableView.setEditing(true, animated: true)
        myTableView.reloadData()
        showleftBarButtonCancel()
        hiddenRightBarbutton()
    }
    
    func btnCancel() {
        myTableView.isEditing = false
        hiddenLeftBarButton()
        showRightBarButtonEdit()
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
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}



