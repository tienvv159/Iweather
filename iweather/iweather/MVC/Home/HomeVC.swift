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

class HomeVC: UIViewController , UITableViewDelegate, UITableViewDataSource, MyCellLastDelegate, SearchVCDelegate{
    
    @IBOutlet weak var myTableView: UITableView!
    var arrCity:[[String : Any]]? = []
    var arrTemperatureF:[Int] = []
    var arrTemperatureC:[Int] = []
    let model:IweatheModel? = nil
    var temperature:String = "F"
    var arrConvertTemp:[Int]? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }

    func registerCell()  {
        let nib1 = UINib(nibName: "MyCellLast", bundle: nil)
        myTableView.register(nib1, forCellReuseIdentifier: "MyCellLast")
        
        let nib2 = UINib(nibName: "MyCellWeather", bundle: nil)
        myTableView.register(nib2, forCellReuseIdentifier: "MyCellWeather")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrCity?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (arrCity?.count) ?? 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellLast", for: indexPath) as! MyCellLast
            cell.delegate = self
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellWeather", for: indexPath) as! MyCellWeather
            
            let dic:[String : Any] = (arrCity?[indexPath.row]) ?? [:]
            cell.lblCity.text = dic["city"] as? String
            
            if temperature == "F"{
                cell.lblTemperature.text = String(arrTemperatureF[indexPath.row])
            }else if temperature == "C"{
                cell.lblTemperature.text = String(arrTemperatureC[indexPath.row])
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
            arrCity?.remove(at: indexPath.row)
            arrTemperatureF.remove(at: indexPath.row)
            arrTemperatureC.remove(at: indexPath.row)
            myTableView.reloadData()
        }
    }
    
    func checkTapToAddLocation(check: Bool) {
        if check == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.delegate = self // set delegate cho SearchVC
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func getAPI(loation:String) {
        let apiString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(loation.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

            NetworkManager.share.callApi(api: apiString) { model in
                if let model = model{
                    //print(model.tempF)
                    self.arrCity?.append(model.location)
                    self.arrTemperatureF.append(model.tempF)
                    self.arrTemperatureC.append(model.tempC)
                    self.myTableView.reloadData()
                }else{
                    // show alert
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeDetailVC")
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    func textSearch(text: String) {
        getAPI(loation: text)
    }
    
    func checkTapToChangerTemperature(check: Bool) {
        if check == true {
            if temperature == "F"{
                temperature = "C"
            }else if temperature == "C"{
                temperature = "F"
            }
            myTableView.reloadData()
        }
    }
}
