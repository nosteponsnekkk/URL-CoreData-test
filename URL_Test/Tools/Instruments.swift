//
//  Instruments.swift
//  URL_Test
//
//  Created by Олег Наливайко on 11.09.2023.
//

import Foundation
import UIKit


func urlToImage(url string: String, completion: @escaping (UIImage?) -> Void){
    DispatchQueue.global(qos: .userInitiated).async {
        
        guard let url = URL(string: string) else {return}
        
        do {
          let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                completion(image)
            }
        } catch  {
            print(error.localizedDescription)
        }
           
    }
    
    
}
