//
//  SearchVC.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit
import RealmSwift
protocol SearchVCDelegate: NSObjectProtocol{
    func textSearch(_ text:String)
}

class SearchVC: UIViewController {
    @IBOutlet weak var myTableVIew: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    weak var delegate:SearchVCDelegate! = nil
    var modelSearch:SearchModel? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        getAPI(location: mySearchBar.text ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySearchBar.becomeFirstResponder()
        
        let nib = UINib(nibName: "MyCellSearch", bundle: nil)
        myTableVIew.register(nib, forCellReuseIdentifier: "CellSearch")
        
    }
    
    func getAPI(location:String) {
        let stringAPI = "https://www.yahoo.com/news/_td/api/resource/WeatherSearch;text=\(location.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")?bkt=newsdmcntr&device=desktop&feature=cacheContentCanvas%2CvideoDocking%2CnewContentAttribution%2Clivecoverage%2Cfeaturebar%2CdeferModalCluster%2CspecRetry%2CnewLayout%2Csidepic%2CcanvassOffnet%2CntkFilmstrip%2CautoNotif&intl=us&lang=en-US&partner=none&prid=97v352hckf2mk&region=US&site=fp&tz=Asia%2F&ver=2.0.7450001&returnMeta=true"
        
        NetworkManager.share.callApiSearch(stringAPI) { (model) in
            self.modelSearch = model
            self.myTableVIew.reloadData()
        }
    }
    
    
    @IBAction func didCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension SearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.getAPI(location: searchText)
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil{ // phải set delegate cho SearchVC
            if let textSearch = modelSearch?.datas[indexPath.row].qualifiedName{
                delegate.textSearch(textSearch)
            }else{
                self.showAlert(titleAlert: "Notification", message: "error info weather", titleAction: "OK")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelSearch?.datas.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSearch", for: indexPath) as! MyCellSearch
        if let model = modelSearch?.datas{
            cell.lblResulfSearch.text = "\(model[indexPath.row].qualifiedName) - \(model[indexPath.row].country)"
        }else {
            // no value
        }
        return cell
    }
}
