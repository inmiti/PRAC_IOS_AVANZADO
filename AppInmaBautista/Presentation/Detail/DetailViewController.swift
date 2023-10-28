//
//  DetailViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//

import UIKit
import MapKit

protocol DetailViewControllerDelegate {
    var viewState: ((DetailViewState) -> Void)? { get set }
    func onViewAppear()
}

enum DetailViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero, locations: Locations)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageHero: UIImageView!
    @IBOutlet weak var nameHero: UILabel!
    @IBOutlet weak var descriptionHero: UITextView!
    
    var viewModel: DetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObservers()
    }
    
    func initViews() {
        
    }
    
    func setObservers() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    break
                case .update(let hero, let locations):
                    break
                }
            }
        }
    }
    
    private func updateViews(hero:Hero, locations: Locations) {
        
        nameHero.text = hero.name
        descriptionHero.text = hero.description
        let url = hero.photo
        if let urlString = url?.absoluteString {
            imageHero.setImage(photo: urlString)
            makeRounded(image: imageHero)
        }
        else {
            print("Error: \(NetworkErrors.notImage)")
            return}
    }
    
    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
}
