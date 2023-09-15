//
//  Extensions.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import Foundation
import UIKit

extension UIColor {
    static let primary = #colorLiteral(red: 0.1066659316, green: 0.1317585111, blue: 0.1881643832, alpha: 1)
    static let grayYellow = #colorLiteral(red: 0.9499329925, green: 0.9495629668, blue: 0.9372775555, alpha: 1)
    static let grayPink = #colorLiteral(red: 0.9254901961, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
    static let blue = #colorLiteral(red: 0.383120358, green: 0.5740223527, blue: 0.9855667949, alpha: 1)
    static let transparentWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2005309021)
    static let lightLightGray = #colorLiteral(red: 0.8000000119, green: 0.8000000119, blue: 0.8000000119, alpha: 1)
    static let sand = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9215686275, alpha: 1)
}

extension Date {
    func timeAgoDisplay(timeStamp: String?) -> String{
        
        if let timeStamp = timeStamp {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = dateFormatter.date(from: timeStamp) else {return "Some time ago..."}
            
            
            let formatter = RelativeDateTimeFormatter()
            formatter.locale = Locale(identifier: "en_GB")
            
            return formatter.localizedString(for: date, relativeTo: self)
        }
        
        return "Some time ago..."
    }
   
}

extension String {
    func formattedNewsDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "EEEE dd yyyy" 
            return dateFormatter.string(from: date)
        }
        
        return "Some time ago..."
    }
}


extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
  
    


