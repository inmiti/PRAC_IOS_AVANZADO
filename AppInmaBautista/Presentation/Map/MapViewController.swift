//
//  MapViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//


import UIKit
import MapKit

protocol MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)? { get set }
    func onViewAppear()
}
enum MapViewState {
    case loading
    case updatedData(locations: Locations )
    
}
class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var viewModel: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setObserver()
        viewModel?.onViewAppear()
    }
    
    func initViews() {
        mapView.delegate = self
    }
    func setObserver() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    break
                case .updatedData(locations: let locations):
                    self.updateView(locations: locations)
                }
            }
        }
    }
    
    private func updateView(locations: Locations) {
        locations.forEach {
            mapView.addAnnotation(
                HeroLocationAnnotation(
                    title: $0.hero?.id,
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
    }
}
