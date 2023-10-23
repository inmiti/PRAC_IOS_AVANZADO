//
//  UImageRemote.swift
//  AppInmaBautista
//
//  Created by ibautista on 23/10/23.
//

import UIKit

extension UIImageView {
    
    func setImage(url: URL) {
        var apiProviderImage = ApiProvider()
        
        apiProviderImage.downloadImage(url: url) { [weak self] result in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                case .failure(let error):
                    print("Error: \(error)")
            }
        }
    }
    
    
}
