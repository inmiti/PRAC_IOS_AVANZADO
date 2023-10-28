//
//  HeroeCell.swift
//  AppInmaBautista
//
//  Created by ibautista on 23/10/23.
//

import UIKit

class HeroeCell: UITableViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    
    static let identifier: String = "HeroeCell"
    static let estimatedHeight: CGFloat = 160
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        heroImage.image = nil
        heroNameLabel.text = nil
        heroDescriptionLabel.text = nil
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    func updateViewCell(//id: String? = nil,
                        name: String? = nil,
                        description: String? = nil,
                        photo: String? = nil){
        heroNameLabel.text = name
        heroDescriptionLabel.text = description
        if let photo = photo {
            heroImage.setImage(photo: photo)
        } else {
            print("Error: \(NetworkErrors.notImage)")
            return }
    }
}
