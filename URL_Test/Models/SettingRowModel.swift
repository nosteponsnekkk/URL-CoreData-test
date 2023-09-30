//
//  SettingRowModel.swift
//  URL_Test
//
//  Created by Олег Наливайко on 30.09.2023.
//

import Foundation
import UIKit

struct SettingRowModel {
    let title: String
    let icon: UIImage?
    let bgcolor: UIColor
    let handler: (() -> Void)
}

struct Section {
    let title: String
    let options: [SettingRowModel]
}
