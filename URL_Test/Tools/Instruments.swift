//
//  Instruments.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation
import UIKit


//MARK: - Creates AC for error outputs
public func showError(title: String, message: String) -> UIAlertController{
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
    ac.view.tintColor = .primary
    return ac
}

