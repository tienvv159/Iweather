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
    let model:IweatheModel? = nil
    var temperature:String = "F"
    var arrConvertTemp:[Int]? = []
    var listModel:[IweatheModel] = []
    var listKeySearch:[String] = []
   // var keySearch:String = ""
    override func viewDidAppear(_ animated: Bool) {
        getDataFromRealm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getDataFromRealm()
        registerCell()
    }
    
    func getDataFromRealm() {
        do{
            let realm = try Realm()
            // chả về 1 mảng các model đã lưu trong reaml
           let list = realm.objects(IweatheModel.self)
            listModel.removeAll()
            listKeySearch.removeAll()
            for model in list {
                listModel.append(model)
                listKeySearch.append(model.keySearch)
            }
            
            
            
            let downloadGroup = DispatchGroup()
            for item in listKeySearch{
                downloadGroup.enter()
                self.getAPI(item, complete: { 
                    downloadGroup.leave()
                })
            }
            downloadGroup.notify(queue: DispatchQueue.main) {
                self.myTableView.reloadData()
            }
            
        }catch let err{
            print(err)
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
                if temperature == "F"{
                    cell.lblTemperature.text = String(listModel[indexPath.row ].tempF)
                }else if temperature == "C" {
                    cell.lblTemperature.text = String(listModel[indexPath.row].tempC)
                }
                let text = listModel[indexPath.row].lastBuildDate.description
                let arr = text.components(separatedBy: " ")
                cell.lblTime.text = "\(arr[4]) \(arr[5])"
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
                    
                }catch{}
                
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
                    // show alert
                    debugPrint(error.localizedDescription)
                }
                
                
            }else{
                // show alert
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
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeDetailVC")
                navigationController?.present(vc, animated: true, completion: nil)
            }
            
        }
    
        func textSearch(_ text: String) {
            getAPI(text, complete: {
                self.myTableView.reloadData()
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
    }
