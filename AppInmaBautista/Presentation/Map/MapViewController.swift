//
//  MapViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//

import UIKit
import MapKit

// MARK: - Protocol -
protocol MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)? { get set }
    func onViewAppear()
}

// MARK: - ViewState -
enum MapViewState {
    case loading(_ isLoading: Bool)
    case updatedData(locations: LocationsDAO )
}

class MapViewController: UIViewController {
    // MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Delegate - 
    var viewModel: MapViewControllerDelegate?
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        viewModel?.onViewAppear()
    }
    
    // MARK: - Private functions -
    private func initViews() {
        mapView.delegate = self
    }
    
    private func setObserver() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async { [weak self] in
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading
                    case .updatedData(locations: let locations):
                        self?.updateView(locations: locations)
                }
            }
        }
    }
    
    private func updateView(locations: LocationsDAO) {
        locations.forEach {
            mapView.addAnnotation(
                HeroAnnotation(
//                    title: $0.heroId,
                    coordinate: .init(latitude: Double($0.latitude ?? "") ?? 0,
                                      longitude: Double($0.longitude ?? "") ?? 0)
                )
            )
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
        //TODO: poner en chinchetas imagen del personaje
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        // TODO: Para navegar a detalle cuando pincha 
    }
}
