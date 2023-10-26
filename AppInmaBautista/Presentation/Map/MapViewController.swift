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
    case update(locations: [String] )
    
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
        
    }
    func setObserver() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    break
                case .update:
                    break
                }
            }
        }
        
    }
}
