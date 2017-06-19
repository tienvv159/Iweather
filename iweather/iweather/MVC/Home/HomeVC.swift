//
//  HomeV.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import Alamofire

class HomeVC: UIViewController , UITableViewDelegate, UITableViewDataSource, MyCellLastDelegate, SearchVCDelegate{
    
    @IBOutlet weak var myTableView: UITableView!
    var arrCity:[[String : Any]]? = []
    var arrTemperature:[[String:Any]]? = []
    let model:IweatheModel? = nil
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
            let dic1:[String : Any] = arrTemperature?[indexPath.row] ?? [:]
            cell.lblTemperature.text = dic1["temp"] as? String
            
            return cell

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

            print(apiString)
            NetworkManager.share.callApi(api: apiString) { model in
                if let model = model{
                    self.arrCity?.append(model.location)
                    self.arrTemperature?.append(model.condition)
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
    
    
    
}

