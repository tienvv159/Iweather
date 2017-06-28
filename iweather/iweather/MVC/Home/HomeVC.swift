//
//  HomeV.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SwiftGifOrigin

class HomeVC: UIViewController , UITableViewDelegate, UITableViewDataSource, MyCellLastDelegate, SearchVCDelegate{
    
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    let model:IweatheModel? = nil
    var temperature:String = "F"
    var arrConvertTemp:[Int]? = []
    var listModel:[IweatheModel] = []
    var listCity:[String] = []
    override func viewDidAppear(_ animated: Bool) {
        getDataFromRealm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromRealm()
        registerCell()
        
        
//        let string = "<![CDATA[<img src=\"http://l.yimg.com/a/i/us/we/52/26.gif\"/> <BR /> <b>Current Conditions:</b> <BR />Cloudy <BR /> <BR /> <b>Forecast:</b> <BR /> Mon - Cloudy. High: 55Low: 51 <BR /> Tue - Cloudy. High: 55Low: 50 <BR /> Wed - Rain. High: 54Low: 50 <BR /> Thu - Cloudy. High: 54Low: 50 <BR /> Fri - Scattered Showers. High: 54Low: 48 <BR /> <BR /> <a href=\"http://us.rd.yahoo.com/dailynews/rss/weather/Country__Country/*https://weather.yahoo.com/country/state/city-2460286/\">Full Forecast at Yahoo! Weather</a> <BR /> <BR /> (provided by <a href=\"http://www.weather.com\" >The Weather Channel</a>) <BR /> ]]>".html2String
//        
//        lblDes.text = string
        
    }
    
    func getDataFromRealm() {
        do{
            let realm = try Realm()
            // chả về 1 mảng các model đã lưu trong reaml
           let list = realm.objects(IweatheModel.self)
            listModel.removeAll()
            listCity.removeAll()
            for model in list {
                listModel.append(model)
                listCity.append(model.city)
            }
            
            reloadDataWhenRunApp()
            
        }catch {
            self.showAlert(titleAlert: "Notification", message: "error get data from realm", titleAction: "OK")
        }
        
    }
    
    func reloadDataWhenRunApp() {
        let downloadGroup = DispatchGroup()
        for item in listCity{
            downloadGroup.enter()
            self.getAPI(item, complete: {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == listModel.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellLast", for: indexPath) as! MyCellLast
            cell.delegate = self
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellWeather", for: indexPath) as! MyCellWeather
            
            cell.lblCity.text = listModel[indexPath.row].city
            cell.lblCountry.text = listModel[indexPath.row].country
            if temperature == "F"{
                cell.lblTemperature.text = String(listModel[indexPath.row ].tempF)
            }else if temperature == "C" {
                cell.lblTemperature.text = String(listModel[indexPath.row].tempC)
            }
            let text = listModel[indexPath.row].lastBuildDate.description
            let arr = text.components(separatedBy: " ")
            cell.lblTime.text = "\(arr[4]) \(arr[5])"
            
            if listModel[indexPath.row].code == "0" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_storm")
            }
            if listModel[indexPath.row].code == "1" || listModel[indexPath.row].code == "2" || listModel[indexPath.row].code == "3" || listModel[indexPath.row].code == "4" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_cloudThunder")
            }
            if listModel[indexPath.row].code == "5" || listModel[indexPath.row].code == "6" || listModel[indexPath.row].code == "7" || listModel[indexPath.row].code == "18" || listModel[indexPath.row].code == "46"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_rainSnow")
            }
            if listModel[indexPath.row].code == "8" || listModel[indexPath.row].code == "9" || listModel[indexPath.row].code == "10" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_rainCloud")
            }
            if listModel[indexPath.row].code == "11" || listModel[indexPath.row].code == "12" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_shower")
            }
            if listModel[indexPath.row].code == "13" || listModel[indexPath.row].code == "14" || listModel[indexPath.row].code == "15" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_snowWind")
            }
            if listModel[indexPath.row].code == "16"  {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_snow")
            }
            if listModel[indexPath.row].code == "17" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_hail")
            }
            if listModel[indexPath.row].code == "19" || listModel[indexPath.row].code == "20" || listModel[indexPath.row].code == "21" || listModel[indexPath.row].code == "22" || listModel[indexPath.row].code == "23"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_windDustWaring")
            }
            if listModel[indexPath.row].code == "24" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_wind")
            }
            if listModel[indexPath.row].code == "25" || listModel[indexPath.row].code == "26" || listModel[indexPath.row].code == "44"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_cloud")
            }
            if listModel[indexPath.row].code == "27"  || listModel[indexPath.row].code == "29" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_moonBigCloud")
            }
            if  listModel[indexPath.row].code == "28" || listModel[indexPath.row].code == "30" {
                cell.imgCell.image = #imageLiteral(resourceName: "ic_sunBigCloud")
            }
            if  listModel[indexPath.row].code == "31" || listModel[indexPath.row].code == "32" || listModel[indexPath.row].code == "36"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_sun")
            }
            if  listModel[indexPath.row].code == "33" || listModel[indexPath.row].code == "34"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_roller")
            }
            if  listModel[indexPath.row].code == "35"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_shootingStar")
            }
            if  listModel[indexPath.row].code == "37" || listModel[indexPath.row].code == "38" || listModel[indexPath.row].code == "39" || listModel[indexPath.row].code == "45" || listModel[indexPath.row].code == "47"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_thunder")
            }
            if  listModel[indexPath.row].code == "40"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_sunRainCloud")
            }
            if  listModel[indexPath.row].code == "41" || listModel[indexPath.row].code == "42" || listModel[indexPath.row].code == "43"{
                cell.imgCell.image = #imageLiteral(resourceName: "ic_thunderSnow")
            }

            
            return cell
        }
        }
    
        // delete row
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                do
                {
                    let realm = try Realm()
                    
                    try! realm.write {
                        realm.delete(listModel[indexPath.row])
                        listModel.remove(at: indexPath.row)
                        myTableView.reloadData()
                    }
                    
                }catch{
                    self.showAlert(titleAlert: "Notification", message: "Error delete element realm", titleAction: "OK")
                }
                
            }
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
        
        let apiString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(location.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        EZLoadingActivity.show("Loading", disableUI: true)
        NetworkManager.share.callApi(apiString) { model in
            EZLoadingActivity.hide(true, animated: true)
            if let model = model{
                self.myTableView.reloadData()
                do
                {
                    let realm = try Realm()
                    model.keySearch = location
                    try realm.write {
                        realm.add(model, update: true)
                    }
                }
                catch{
                    self.showAlert(titleAlert: "Notification", message: "error save realm", titleAction: "OK")
                }
                
                
            }else{
                self.showAlert(titleAlert: "Notification", message: "error loading info. please try again", titleAction: "OK")
            }
            
            complete()
        }
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row != listModel.count {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
                vc.listModelIndexpath = listModel
                vc.row = indexPath.row
                vc.checkTemp = temperature
                navigationController?.present(vc, animated: true, completion: nil)
            }
            
        }
    
        func textSearch(_ text: String) {
            getAPI(text, complete: {
                self.myTableView.reloadData()
                self.getDataFromRealm()
            })
        }
        
        func checkTapToChangerTemperature(_ check: Bool) {
            if check == true {
                if temperature == "F"{
                    temperature = "C"
                }else if temperature == "C"{
                    temperature = "F"
                }
                myTableView.reloadData()
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


