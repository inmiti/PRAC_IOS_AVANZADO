//
//  MapViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//

import Foundation

class MapViewModel: MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)?
    var heroes: Heroes
    var locations: Locations?
    
    private let apiprovider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    init(heroes: Heroes, apiprovider: ApiProviderProtocol, secureDataProvider: SecureDataProviderProtocol) {
        self.apiprovider = apiprovider
        self.secureDataProvider = secureDataProvider
        self.heroes = heroes
    }
    
    func onViewAppear() {
        viewState?(.loading)
        DispatchQueue.global().async {
            for hero in self.heroes {
                let token = self.secureDataProvider.getToken()
                self.apiprovider.getLocations(token: token, heroID: hero.id) { [weak self] result in
                    switch result {
                    case .success(let locations):
                        DispatchQueue.main.async {
                            self?.locations = locations
                         //TODO: Borrar locations en coredata, salvar locations en coredata y loadLocations
                            
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
           
                
            }
        }
        
    }
    
    
    
}
