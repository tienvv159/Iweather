//
//  MyHeaderInSection.swift
//  iweather
//
//  Created by Vu Van Tien on 6/22/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyHeaderInSection: UIView , UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var imgBackgroundSection: UIImageView!
    @IBOutlet weak var myCollectionTempHour: UICollectionView!
    let statusWeather:StatusWeather = StatusWeather()
    var modelIndexpath: IweatheModel? {
        get {
            return tempModel
        }
        set {
            tempModel = newValue
            handlingData(model: newValue)
            handlingSunsetSunrice(model: newValue)
        }
    }
    var indexSunset = 0
    var indexSunrise = 0
    var listData:[TempHoursModel] = []
    private var tempModel: IweatheModel? = nil {
        didSet {
            
        }
    }
    
    var checkTemp: String? {
        get{
            return checkValue
        }
        set{
            checkValue = newValue!
        }
    }
    private var checkValue = ""
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "myCellTempHour", bundle: nil)
        myCollectionTempHour.register(nib, forCellWithReuseIdentifier: "myCellTempHour")
        myCollectionTempHour.delegate = self
        myCollectionTempHour.dataSource = self
        myCollectionTempHour.reloadData()
    }
    
    func handlingData(model:IweatheModel?) {
        var temp:Int = 0
        if checkTemp == "F" {
            temp = model?.tempF ?? 0
        }else if checkTemp == "C"{
            temp = model?.tempC ?? 0
        }
        
        listData = DataTempHours.getData(temp: temp)
        myCollectionTempHour.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCellTempHour", for: indexPath) as! myCellTempHour
        cell.lblTimer.text = listData[indexPath.item].hours
        cell.lblTemp.text = String(listData[indexPath.item].temp)
        let code = listData[indexPath.item].code
        cell.img.image = statusWeather.handlingItem(code: String(code))
        return cell
    }
    
    
    func handlingSunsetSunrice(model: IweatheModel?) {
        // sunset sunrise
        let sunset = model?.sunset
        let arrSunset = sunset?.components(separatedBy: ":")
        let hoursSunset = "\(arrSunset![0])PM"
        
        let sunrise = model?.sunrise
        let arrSunrise = sunrise?.components(separatedBy: ":")
        indexSunrise = Int(arrSunrise![0]) ?? 0
        let hoursSunrise = "\(arrSunrise![0])AM"
        
        for (index, item) in listData.enumerated(){
            if hoursSunset == item.hours {
                indexSunset = index + 2
                let hours = tempModel?.sunset
                let arrHoursS = hours?.components(separatedBy: " ")
                let hoursS = "\(arrHoursS![0])PM"
                
                let model:TempHoursModel? = TempHoursModel(temp: "sunset", code: 48, hours: hoursS)
                listData.insert(model! , at: (1 + index))
            }
        }
        for (index, item) in listData.enumerated() {
            if hoursSunrise == item.hours {
                indexSunrise = index + 1
                let hourr = tempModel?.sunset
                let arrHoursR = hourr?.components(separatedBy: " ")
                let hoursR = "\(arrHoursR![0])AM"
                
                let model:TempHoursModel? = TempHoursModel(temp: "sunrise", code: 49, hours: hoursR)

                listData.insert(model!, at: (1 + index))
            }
        }
        myCollectionTempHour.reloadData()
    }
    
}

extension MyHeaderInSection : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIImageView {
    func imageWithCode(code: String) {
    }
}
