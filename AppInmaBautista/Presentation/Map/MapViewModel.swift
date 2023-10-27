//
//  MapViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//

import Foundation

class MapViewModel: MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)?
    var heroes: HeroesDAO
    var locations: Locations = []
    var locationsDAO: LocationsDAO = []
    
    private var thereAreData: Bool {
        coreDataProvider.loadLocationsDAO().isEmpty == false
    }
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let coreDataProvider: CoreDataProviderProtocol
    private let saveDataFromApi: SaveDataFromApiDelegate
    
    init(heroes: HeroesDAO,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProviderProtocol,
         saveDataFromApi: SaveDataFromApiDelegate = SaveDataFromApi()
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.heroes = heroes
        self.coreDataProvider = coreDataProvider
        self.saveDataFromApi = saveDataFromApi
    }
    
    func onViewAppear() {
        viewState?(.loading)
        
        // Observador de notification center que avisa de que están los datos en coredata: entonces ejecuto self?.viewState?(.updatedData(locations: self?.locations ?? [] ))
//        if thereAreData {
//                locationsDAO = coreDataProvider.loadLocationsDAO()
//                viewState?(.updatedData(locations: locationsDAO))
//            } else {
        
//        saveDataFromApi.saveLocations(heros: heroes, completion: { [weak self] in
//                    // La clausura se ejecuta cuando se ha completado saveHeroes
//                    self?.locationsDAO = self?.coreDataProvider.loadLocationsDAO() ?? []
//                    DispatchQueue.main.async {
//                        self?.viewState?(.updatedData(locations: self?.locationsDAO ?? []))
//                    }
//                })
//            }
    }
    
    private func apiRequest() {
        coreDataProvider.deleteAllLocations()
        guard let token = self.secureDataProvider.getToken() else {return}
        for h in heroes {
            DispatchQueue.global().async {
                self.apiProvider.getLocations(token: token, heroID: h.id) { [weak self] result in
                    switch result {
                        case .success(let locations):
                            DispatchQueue.main.async {
                                self?.locations.append(contentsOf: locations)
                                self?.viewState?(.updatedData(locations: self?.locationsDAO ?? []))

//                                          self?.locations.forEach{self?.coreDataProvider.saveLocationDAO(location: $0)}
//                                self?.locationsDAO = self?.coreDataProvider.loadLocationsDAO() ?? []
                            }
                        case .failure(let error):
                            print("Error: \(error)")
                    }
                }
            }
        }
    }
}
