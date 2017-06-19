//
//  HomeV.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import Alamofire

class HomeVC: UIViewController , UITableViewDelegate, UITableViewDataSource, MyCellLastDelegate{
    
    @IBOutlet weak var myTableView: UITableView!
    let model:IweatheModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
        getAPI()
        
    }

    func registerCell()  {
        let nib = UINib(nibName: "MyCellLast", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "MyCellLast")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellLast", for: indexPath) as! MyCellLast
        cell.delegate = self  
        
        return cell
    }
    
    func checkTapToAddLocation(check: Bool) {
        if check == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            
            navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func getAPI() {
        let apiString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

        
        //NetworkManager.share.callApi(api: apiString) {
            NetworkManager.share.callApi(api: apiString) { model in
                if let 
        }
    
    }
    
    
    
    
}

