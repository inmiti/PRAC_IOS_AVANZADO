//
//  UImageRemote.swift
//  AppInmaBautista
//
//  Created by ibautista on 23/10/23.
//

import UIKit

extension UIImageView {
    
    func setImage(photo: String) {
        let apiProviderImage = ApiProvider()
        guard let url = URL(string: photo) else {return}
        apiProviderImage.downloadImage(for: url) { [weak self] result in
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
