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
    case update(hero: HeroDAO, locations: Locations)
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
        viewModel?.onViewAppear()
    }
    
    func initViews() {
//        mapView.delegate = self
    }
    
    func setObservers() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    break
                case .update(let hero, let locations):
                    self.updateViews(hero: hero, locations: locations)
                }
            }
        }
    }
    
    private func updateViews(hero:HeroDAO, locations: Locations) {
        nameHero.text = hero.name
        descriptionHero.text = hero.heroDescription

        imageHero.setImage(photo: hero.photo ?? "")
        makeRounded(image: imageHero)
        
        locations.forEach {
            mapView.addAnnotation(
                HeroAnnotation(
                    title: hero.name,
                    coordinate: .init(latitude: Double($0.latitude ?? "") ?? 0.0,
                                      longitude: Double($0.longitude ?? "") ?? 0.0)
                )
            )
        }
        centerMapAroundLocations(locations: locations)
    }
    
    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
    
    private func centerMapAroundLocations(locations: [Location]) {
        if locations.isEmpty {
            return
        }
       
        var minLatitude = Double(locations.first?.latitude ?? "") ?? 0.0
        var maxLatitude = minLatitude
        var minLongitude = Double(locations.first?.longitude ?? "") ?? 0.0
        var maxLongitude = minLongitude

        for location in locations {
            if let latitude = Double(location.latitude ?? ""), let longitude = Double(location.longitude ?? "") {
                minLatitude = min(minLatitude, latitude)
                maxLatitude = max(maxLatitude, latitude)
                minLongitude = min(minLongitude, longitude)
                maxLongitude = max(maxLongitude, longitude)
            }
        }
        
        let center = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2,
                                            longitude: (minLongitude + maxLongitude) / 2)
        let latitudeDelta = (maxLatitude - minLatitude) * 1.3
        let longitudeDelta = (maxLongitude - minLongitude) * 1.3
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta,
                                    longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}

