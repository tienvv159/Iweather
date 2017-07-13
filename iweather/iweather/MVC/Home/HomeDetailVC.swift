//
//  HomeDetailVC.swift
//  iweather
//
//  Created by Vu Van Tien on 6/19/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class HomeDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPageViewControllerDelegate{
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var pageControl: SMPageControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var checkTemp:String = ""
    let color:[UIColor] = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.brown]
    var  frames = CGRect(x: 0, y: 0, width: 0, height: 0)
    var listModel:[IweatheModel]! = nil
    var row:Int = 0
    var checkDirection:Float = 0
    var index:Int = 0
    
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
        
        isOnLocation()
    }
    
    func isOnLocation() {
        let defaults = UserDefaults.standard
        let check = defaults.string(forKey: "isOnLocation")
        
        if check != nil{
            myCollectionView.isPagingEnabled = true
            pageControl.numberOfPages = listModel.count
            pageControl.currentPage = row
            pageControl.setImage(UIImage(named:"locationBlack"), forPage: 0)
            pageControl.setCurrentImage(UIImage(named:"currentimgPage0"), forPage: 0)
            pageControl.pageIndicatorTintColor = UIColor.black
            pageControl.currentPageIndicatorTintColor = UIColor.white
        }else{
            myCollectionView.isPagingEnabled = true
            pageControl.numberOfPages = listModel.count
            pageControl.currentPage = row
            pageControl.pageIndicatorTintColor = UIColor.gray
            pageControl.currentPageIndicatorTintColor = UIColor.white
        }
    }
    
    
    @IBAction func didMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changerPage(_ sender: Any) {
        let page = pageControl.currentPage
        myCollectionView.selectItem(at: IndexPath(row: page, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionCell", for: indexPath) as! MyCollectionViewCell
        cell.modelIndexpath = listModel[indexPath.item]
        cell.checkTemp = checkTemp
        cell.writeDataInView()
        cell.numberRow = listModel.count
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.size.width, height: screenSize.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        index = indexPath.item
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.size.width
        if offSet == width * CGFloat(index){
            pageControl.currentPage = index
        }
    }
    
    @IBAction func didSelectToWeb(_ sender: Any) {
        if let url = NSURL(string: "https://weather.com/en-GB/weather/today/l/VMXX0006:1:VM"){
            UIApplication.shared.openURL(url as URL)
        }
    }
}


extension HomeDetailVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGSize(width: screenSize.size.width, height: screenSize.size.height - 37)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,0,0,0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
