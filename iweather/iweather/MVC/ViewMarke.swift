//
//  ViewMarke.swift
//  iweather
//
//  Created by Vu Van Tien on 7/21/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import UIKit

class ViewMarke: NibDesignable{

    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblValueTemp: UILabel!
    @IBOutlet weak var lblTemp: UILabel!

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blue.cgColor
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
