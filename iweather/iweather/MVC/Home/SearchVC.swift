//
//  SearchVC.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var mySearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
