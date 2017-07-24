//
//  Windself.swift
//  iweather
//
//  Created by Vu Van Tien on 7/21/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class WindCell: UITableViewCell {
    
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var lblDirection: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblChill: UILabel!
    @IBOutlet weak var imgFanSmall: UIImageView!
    @IBOutlet weak var imgFanBig: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(model:IweatheModel) {
        self.lblChill.text = "\(model.chill) COP"
        self.lblSpeed.text = "\(model.speed) mph"
        self.lblDirection.text =  "\(model.direction) WNW"
        changeTintColor(img: self.imgFanBig, color: UIColor.white)
        changeTintColor(img: self.imgFanSmall, color: UIColor.white)
        changeTintColor(img: self.img1, color: UIColor.white)
        changeTintColor(img: self.img2, color: UIColor.white)
        if Int(model.speed)! <= 3{
            self.imgFanBig.startRotating(duration: 4.0)
            self.imgFanSmall.startRotating(duration: 4.0)
        }else if Int(model.speed)! <= 7{
            self.imgFanBig.startRotating(duration: 3.0)
            self.imgFanSmall.startRotating(duration: 3.0)
        }else if Int(model.speed)! <= 10{
            self.imgFanBig.startRotating(duration: 2.0)
            self.imgFanSmall.startRotating(duration: 2.0)
        }else{
            self.imgFanBig.startRotating(duration: 1.0)
            self.imgFanSmall.startRotating(duration: 1.0)
        }
    }
}


extension UIView {
    
    //Start Rotating view
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            
            animate.fromValue = 0.0
            animate.toValue = Float(Double.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    //Stop rotating view
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
}
