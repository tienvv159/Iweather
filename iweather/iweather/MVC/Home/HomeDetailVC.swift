//
//  HomeDetailVC.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class HomeDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var lblStatusToday: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createHeader()
        self.registerCell()
    }
    
    func registerCell() {
        let nib = UINib(nibName: "MyCellTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "MyCell")
    }
    
    func createHeader() {
        let myheader = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170))
        
        let myLableTemp = UILabel(frame: CGRect(x: 0, y: 0, width: myheader.frame.width, height: myheader.frame.height - 20))
        myheader.backgroundColor = UIColor.red
        myLableTemp.textAlignment = .center
        myLableTemp.font = UIFont.systemFont(ofSize: 100)
        myLableTemp.text = "70"
        myheader.addSubview(myLableTemp)
        myTableView.addSubview(myheader)
    }
    
    
    @IBAction func didMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let loadView = Bundle.main.loadNibNamed("MyHeader", owner: self, options: nil)?.first as! MyHeaderInSection
        loadView.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 100)
        return loadView
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
}
