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

class SearchVC: UIViewController , UISearchBarDelegate {
    
    weak var delegate:SearchVCDelegate! = nil
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySearchBar.becomeFirstResponder()
    }
    
    
      @IBAction func didCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //https://www.yahoo.com/news/_td/api/resource/WeatherSearch;text=haiduong?bkt=newsdmcntr&device=desktop&feature=cacheContentCanvas%2CvideoDocking%2CnewContentAttribution%2Clivecoverage%2Cfeaturebar%2CdeferModalCluster%2CspecRetry%2CnewLayout%2Csidepic%2CcanvassOffnet%2CntkFilmstrip%2CautoNotif&intl=us&lang=en-US&partner=none&prid=97v352hckf2mk&region=US&site=fp&tz=Asia%2FHo_Chi_Minh&ver=2.0.7450001&returnMeta=true
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.view.endEditing(true)
        if delegate != nil{ // phải set delegate cho SearchVC
            if let textSearch = mySearchBar.text{
                delegate.textSearch(textSearch)
                
                }else{
                // no location
            }
        }
        self.dismiss(animated: true, completion: nil)

    }
}
