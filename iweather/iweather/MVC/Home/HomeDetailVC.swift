//
//  HomeDetailVC.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class HomeDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPageViewControllerDelegate{
    
    @IBOutlet weak var myPage: UIPageControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var checkTemp:String = ""
    let color:[UIColor] = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.brown]
    var  frames = CGRect(x: 0, y: 0, width: 0, height: 0)
    var listModelIndexpath:[IweatheModel]! = nil
    var row:Int = 0
    var checkDirection:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        myCollectionView.register(nib, forCellWithReuseIdentifier: "myCollectionCell")
        myCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(1)) {
            DispatchQueue.main.async {
                self.myCollectionView.selectItem(at: IndexPath(row: self.row, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
        myPage.numberOfPages = listModelIndexpath.count
        myPage.currentPage = row
    }
    
    @IBAction func didMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePage(_ sender: Any) {
        let pageControl:UIPageControl = sender as! UIPageControl
        let page:Int = pageControl.currentPage
        myCollectionView.selectItem(at: IndexPath(row: page, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModelIndexpath.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as! MyCollectionViewCell
        cell.modelIndexpath = listModelIndexpath[indexPath.item]
        cell.checkTemp = checkTemp
        cell.writeDataInView()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.size.width, height: screenSize.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        myPage.currentPage = indexPath.item
    }
    
    
    @IBAction func didSelectToWeb(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string:"https://weather.com/en-GB/weather/today/l/VMXX0006:1:VM")! as URL)
    }
    
}



extension HomeDetailVC : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.size.width, height: screenSize.size.height - 37)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0,0)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
