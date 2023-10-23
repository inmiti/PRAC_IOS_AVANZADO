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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        heroImage.image = nil
        heroNameLabel.text = nil
        heroDescriptionLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViewCell(name: String, description: String, photo: URL) {
        heroNameLabel.text = name
        heroDescriptionLabel.text = description
        heroImage.setImage(url: photo)
    }
}
