//
//  StringExtension.swift
//  iweather
//
//  Created by Vu Van Tien on 6/27/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

import Foundation
import UIKit
extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
