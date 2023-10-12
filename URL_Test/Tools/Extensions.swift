//
//  Extensions.swift
//  URL_Test
//
//  Created by Олег Наливайко on 10.09.2023.
//

import Foundation
import UIKit

//MARK: - UI Colors
extension UIColor {
    static let primary = #colorLiteral(red: 0.1066659316, green: 0.1317585111, blue: 0.1881643832, alpha: 1)
    static let grayYellow = #colorLiteral(red: 0.9499329925, green: 0.9495629668, blue: 0.9372775555, alpha: 1)
    static let grayPink = #colorLiteral(red: 0.9254901961, green: 0.8823529412, blue: 0.8823529412, alpha: 1)
    static let blue = #colorLiteral(red: 0.383120358, green: 0.5740223527, blue: 0.9855667949, alpha: 1)
    static let transparentWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2005309021)
    static let lightLightGray = #colorLiteral(red: 0.8000000119, green: 0.8000000119, blue: 0.8000000119, alpha: 1)
    static let almostWhiteGray = #colorLiteral(red: 0.9410869479, green: 0.9412410855, blue: 0.9410542846, alpha: 1)
    static let sand = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9215686275, alpha: 1)
    static let lightGreen = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
}

//MARK: - Date-Tools extensions
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

//MARK: - Image-Resizer
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

//MARK: - Greeting for time of day
extension String {
    static func greetingForTimeOfDay() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<22:
            return "Good evening"
        default:
            return "Good night"
        }
    }
}

//MARK: - Add animation for tapping button
extension UIButton {
    
    func addTapAnimations() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    @objc private func buttonTapped() {
                UIView.animate(withDuration: 0.1, animations: { [unowned self] in
                    self.transform = .identity.scaledBy(x: 0.97, y: 0.97)
                }) { _ in
                    UIView.animate(withDuration: 0.1) { [unowned self] in
                        self.transform = .identity
                    }
                }
                
        UINotificationFeedbackGenerator().notificationOccurred(.success)
                               
            }
    
}

//MARK: - Get all the items from collectionView
extension UICollectionView {
    func allItems() -> [UICollectionViewCell] {
        var allItems: [UICollectionViewCell] = []

        for section in 0..<self.numberOfSections {
            for item in 0..<self.numberOfItems(inSection: section) {
                if let cell = self.cellForItem(at: IndexPath(item: item, section: section)) {
                    allItems.append(cell)
                }
            }
        }

        return allItems
    }
}
