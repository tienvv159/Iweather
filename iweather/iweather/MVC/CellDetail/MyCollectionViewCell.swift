//
//  MyCollectionViewCell.swift
//  iweather
//
//  Created by Vu Van Tien on 6/27/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{

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
        if checkTemp == "F" {
            lblTemp.text = String(modelIndexpath.tempF)
        }else if checkTemp == "C"{
            lblTemp.text = String(modelIndexpath.tempC)
        }
        if checkTemp == "F" {
            lblLow.text = String(modelIndexpath.forecast[0].lowF)
            lblHigh.text = String(modelIndexpath.forecast[0].highF)
        }else if checkTemp == "C"{
            lblLow.text = String(modelIndexpath.forecast[0].lowC)
            lblHigh.text = String(modelIndexpath.forecast[0].highC)
        }
        
        self.myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell10Day", for: indexPath) as! MyCellTemp10Day
            if checkTemp == "F"{
                cell.lblDay.text = modelIndexpath.forecast[indexPath.row].day
                cell.lblLow.text = String(modelIndexpath.forecast[indexPath.row].lowF)
                cell.lblHight.text = String(modelIndexpath.forecast[indexPath.row].highF)
            }else if checkTemp == "C"{
                cell.lblDay.text = modelIndexpath.forecast[indexPath.row].day
                cell.lblLow.text = String(modelIndexpath.forecast[indexPath.row].lowC)
                cell.lblHight.text = String(modelIndexpath.forecast[indexPath.row].highC)
            }
            
            if modelIndexpath.forecast[indexPath.row].code == "0" {
                cell.img.image = #imageLiteral(resourceName: "ic_storm")
            }
            if modelIndexpath.forecast[indexPath.row].code == "1" || modelIndexpath.forecast[indexPath.row].code == "2" || modelIndexpath.forecast[indexPath.row].code == "3" || modelIndexpath.forecast[indexPath.row].code == "4" {
                cell.img.image = #imageLiteral(resourceName: "ic_cloudThunder")
            }
            if modelIndexpath.forecast[indexPath.row].code == "5" || modelIndexpath.forecast[indexPath.row].code == "6" || modelIndexpath.forecast[indexPath.row].code == "7" || modelIndexpath.forecast[indexPath.row].code == "18" || modelIndexpath.forecast[indexPath.row].code == "46"{
                cell.img.image = #imageLiteral(resourceName: "ic_rainSnow")
            }
            if modelIndexpath.forecast[indexPath.row].code == "8" || modelIndexpath.forecast[indexPath.row].code == "9" || modelIndexpath.forecast[indexPath.row].code == "10" {
                cell.img.image = #imageLiteral(resourceName: "ic_rainCloud")
            }
            if modelIndexpath.forecast[indexPath.row].code == "11" || modelIndexpath.forecast[indexPath.row].code == "12" {
                cell.img.image = #imageLiteral(resourceName: "ic_shower")
            }
            if modelIndexpath.forecast[indexPath.row].code == "13" || modelIndexpath.forecast[indexPath.row].code == "14" || modelIndexpath.forecast[indexPath.row].code == "15" {
                cell.img.image = #imageLiteral(resourceName: "ic_snowWind")
            }
            if modelIndexpath.forecast[indexPath.row].code == "16"  {
                cell.img.image = #imageLiteral(resourceName: "ic_snow")
            }
            if modelIndexpath.forecast[indexPath.row].code == "17" {
                cell.img.image = #imageLiteral(resourceName: "ic_hail")
            }
            if modelIndexpath.forecast[indexPath.row].code == "19" || modelIndexpath.forecast[indexPath.row].code == "20" || modelIndexpath.forecast[indexPath.row].code == "21" || modelIndexpath.forecast[indexPath.row].code == "22" || modelIndexpath.forecast[indexPath.row].code == "23"{
                cell.img.image = #imageLiteral(resourceName: "ic_windDustWaring")
            }
            if modelIndexpath.forecast[indexPath.row].code == "24" {
                cell.img.image = #imageLiteral(resourceName: "ic_wind")
            }
            if modelIndexpath.forecast[indexPath.row].code == "25" || modelIndexpath.forecast[indexPath.row].code == "26" || modelIndexpath.forecast[indexPath.row].code == "44"{
                cell.img.image = #imageLiteral(resourceName: "ic_cloud")
            }
            if modelIndexpath.forecast[indexPath.row].code == "27"  || modelIndexpath.forecast[indexPath.row].code == "29" {
                cell.img.image = #imageLiteral(resourceName: "ic_moonBigCloud")
            }
            if  modelIndexpath.forecast[indexPath.row].code == "28" || modelIndexpath.forecast[indexPath.row].code == "30" {
                cell.img.image = #imageLiteral(resourceName: "ic_sunBigCloud")
            }
            if  modelIndexpath.forecast[indexPath.row].code == "31" || modelIndexpath.forecast[indexPath.row].code == "32" || modelIndexpath.forecast[indexPath.row].code == "36"{
                cell.img.image = #imageLiteral(resourceName: "ic_sun")
            }
            if  modelIndexpath.forecast[indexPath.row].code == "33" || modelIndexpath.forecast[indexPath.row].code == "34"{
                cell.img.image = #imageLiteral(resourceName: "ic_roller")
            }
            if  modelIndexpath.forecast[indexPath.row].code == "35"{
                cell.img.image = #imageLiteral(resourceName: "ic_shootingStar")
            }
            if  modelIndexpath.forecast[indexPath.row].code == "37" || modelIndexpath.forecast[indexPath.row].code == "38" || modelIndexpath.forecast[indexPath.row].code == "39" || modelIndexpath.forecast[indexPath.row].code == "45" || modelIndexpath.forecast[indexPath.row].code == "47"{
                cell.img.image = #imageLiteral(resourceName: "ic_thunder")
            }
            if  modelIndexpath.forecast[indexPath.row].code == "40"{
                cell.img.image = #imageLiteral(resourceName: "ic_sunRainCloud")
            }
            if  modelIndexpath.forecast[indexPath.row].code == "41" || modelIndexpath.forecast[indexPath.row].code == "42" || modelIndexpath.forecast[indexPath.row].code == "43"{
                cell.img.image = #imageLiteral(resourceName: "ic_thunderSnow")
            }
            return cell
        }else if indexPath.row == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellInfoLocation", for: indexPath) as! MyCellInfomationLocation
            cell.lblCity.text = modelIndexpath.city
            cell.lblLat.text = modelIndexpath.lat
            cell.lblLong.text = modelIndexpath.long
            cell.lblCountry.text = modelIndexpath.country
            cell.lblRegion.text = modelIndexpath.region

            return cell
        }else if indexPath.row == 11{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellInforWeather", for: indexPath) as! MyCellInfomationWeather
            cell.lblChill.text = "\(modelIndexpath.chill) HP"
            cell.lblSpeed.text = "\(modelIndexpath.speed) km/h"
            cell.lblSunrise.text = modelIndexpath.sunrise
            cell.lblSunset.text = modelIndexpath.sunset
            cell.lblPressure.text = "\(modelIndexpath.pressure) mb"
            cell.lblDirection.text = "\(modelIndexpath.direction) Kd"
            cell.lblVisibility.text = "\(modelIndexpath.visibility) km"
            cell.lblHumidity.text = "\(modelIndexpath.humidity) %"
            return cell
        }
        return UITableViewCell.init()
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = Bundle.main.loadNibNamed("MyHeader", owner: self, options: nil)?.first as! MyHeaderInSection
        header.frame = CGRect(x: 0, y: 200, width: self.contentView.frame.width, height: 100)
        header.modelIndexpath = modelIndexpath
        header.checkTemp = checkTemp
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
    
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print(scrollView.contentOffset.y)
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
