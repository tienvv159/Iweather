//
//  MyCollectionViewCell.swift
//  iweather
//
//  Created by Vu Van Tien on 6/27/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell{

    var modelIndexpath:IweatheModel! = nil
    @IBOutlet weak var myImgDetail: UIImageView!
    @IBOutlet weak var myViewDetail: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var lblStatusToday: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDayInWeek: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    var checkTemp:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
    }
    
    
    func registerCell() {
        let nib10Day = UINib(nibName: "MyCellTemp10Day", bundle: nil)
        myTableView.register(nib10Day, forCellReuseIdentifier: "MyCell10Day")
        
        let nibInfoLocation = UINib(nibName: "MyCellInfomationLocation", bundle: nil)
        myTableView.register(nibInfoLocation, forCellReuseIdentifier: "MyCellInfoLocation")
        
        let nibInfoWeather = UINib(nibName: "MyCellInfomationWeather", bundle: nil)
        myTableView.register(nibInfoWeather, forCellReuseIdentifier: "MyCellInforWeather")
        
    }
    
    func writeDataInView() {
        lblCity.text = modelIndexpath.city
        lblStatusToday.text = modelIndexpath.text
        let text = modelIndexpath.lastBuildDate
        let arr = text.components(separatedBy: " ")
        lblDayInWeek.text = "\(arr[0]) \(arr[1]) \(arr[2]) \(arr[3])"
        checkTemp == "F" ? (lblTemp.text = String(modelIndexpath.tempF)) : (lblTemp.text = String(modelIndexpath.tempC))
        
        if checkTemp == "F" {
            lblLow.text = String(modelIndexpath.forecast[0].lowF)
            lblHigh.text = String(modelIndexpath.forecast[0].highF)
        }else if checkTemp == "C"{
            lblLow.text = String(modelIndexpath.forecast[0].lowC)
            lblHigh.text = String(modelIndexpath.forecast[0].highC)
        }
        
        self.myTableView.reloadData()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > 0{
            //scroll up
            UIView.animate(withDuration: 0.3, animations: {
                self.myViewDetail.frame.origin.y = 5
                self.myViewDetail.bounds.size.height = 70
                self.myTableView.frame.origin.y = 75
                self.myTableView.frame.size.height = self.contentView.frame.size.height - 75
            })
        }else if scrollView.contentOffset.y < 0 {
            // scroll down
            UIView.animate(withDuration: 0.3, animations: {
                self.myViewDetail.frame.origin.y = 20
                self.myViewDetail.bounds.size.height = 200
                self.myTableView.frame.origin.y = 220
                self.myTableView.frame.size.height = self.contentView.frame.size.height - 220
            })
            myTableView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}


extension MyCollectionViewCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("MyHeader", owner: self, options: nil)?.first as! MyHeaderInSection
        header.frame = CGRect(x: 0, y: 200, width: self.contentView.frame.width, height: 100)
        header.checkTemp = checkTemp
        header.modelIndexpath = modelIndexpath
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 10 {
            return 40
        }else if indexPath.row == 10{
            return 165
        }else {
            return 280
        }
    }
}


extension MyCollectionViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell10Day", for: indexPath) as! MyCellTemp10Day
            cell.setupCell(modelForcast: modelIndexpath.forecast[indexPath.item], temp: checkTemp, modelWeather: modelIndexpath)
            return cell
        }else if indexPath.row == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellInfoLocation", for: indexPath) as! MyCellInfomationLocation
            cell.setupCell(modelIndexpath: modelIndexpath)
            return cell
        }else if indexPath.row == 11{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellInforWeather", for: indexPath) as! MyCellInfomationWeather
            cell.setupCell(modelIndexpath: modelIndexpath)
            return cell
        }
        return UITableViewCell.init()
    }
}
