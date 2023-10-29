//
//  MapViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//

import Foundation

class MapViewModel: MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)?
    var heroesDAO: HeroesDAO
    var locations: Locations = []
    var locationsDAO: LocationsDAO = []
    
    private var thereAreData: Bool {
        coreDataProvider.loadLocationsDAO().isEmpty == false
    }
    
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let coreDataProvider: CoreDataProviderProtocol
    private let saveDataFromApi: SaveDataFromApiProtocol
    
    init(heroesDAO: HeroesDAO,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProviderProtocol,
         saveDataFromApi: SaveDataFromApiProtocol = SaveDataFromApi()
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.heroesDAO = heroesDAO
        self.coreDataProvider = coreDataProvider
        self.saveDataFromApi = saveDataFromApi
    }
    
    func onViewAppear() {
        viewState?(.loading)
    
        let dispatchGroup = DispatchGroup()
        coreDataProvider.deleteAllLocations()

        for hero in heroesDAO {
            dispatchGroup.enter()
            saveDataFromApi.saveLocations(hero: hero) { [weak self] in
                DispatchQueue.main.async {
                    self?.locations.forEach { location in
                        self?.coreDataProvider.saveLocationDAO(location: location)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.locationsDAO = self.coreDataProvider.loadLocationsDAO()
            self.viewState?(.updatedData(locations: self.locationsDAO))
        }
    }
}
