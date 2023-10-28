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
    
    
}
