//
//  MyHeaderInSection.swift
//  iweather
//
//  Created by Vu Van Tien on 6/22/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class MyHeaderInSection: UIView , UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var myCollectionTempHour: UICollectionView!
    var modelIndexpath:IweatheModel? = nil
    var checkTemp = ""
    let arrHours = ["1AM", "2AM", "3AM", "4AM", "5AM","6AM", "7AM", "8AM", "9AM", "10AM", "11AM", "12AM", "1PM", "2PM", "3PM", "4PM", "5PM","6PM", "7PM", "8PM", "9PM", "10PM", "11PM", "12PM"]
    
    override func awakeFromNib() {
        let nib = UINib(nibName: "myCellTempHour", bundle: nil)
        myCollectionTempHour.register(nib, forCellWithReuseIdentifier: "myCellTempHour")
        myCollectionTempHour.delegate = self
        myCollectionTempHour.dataSource = self
        myCollectionTempHour.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCellTempHour", for: indexPath) as! myCellTempHour
        cell.backgroundColor = UIColor.white
        cell.lblTimer.text = arrHours[indexPath.row]
        if checkTemp == "F" {
            //let temp = modelIndexpath?.tempF
            let random = arc4random_uniform(30) + 25
            cell.lblTemp.text = String(random)
        }
        return cell
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
