//
//  SaveLocations.swift
//  AppInmaBautista
//
//  Created by ibautista on 27/10/23.
//

import Foundation

protocol SaveDataFromApiDelegate {
    func saveHeroes(completion: @escaping () -> Void)
    func saveLocations(heros: HeroesDAO, completion: @escaping () -> Void)
}

class SaveDataFromApi: SaveDataFromApiDelegate {
    
    private var apiProvider: ApiProviderProtocol
    private var secureDataProvider: SecureDataProviderProtocol
    private var coreDataProvider: CoreDataProviderProtocol
    
    var heroes: Heroes = []
    var heroesDAO: HeroesDAO = []
    var locations: Locations = []
    var locationsDAO: LocationsDAO = []
    
    private var token: String {
        return secureDataProvider.getToken() ?? ""
    }
    
    init(apiProvider: ApiProviderProtocol = ApiProvider(),
         secureDataProvider: SecureDataProviderProtocol = SecureDataProvider(),
         coreDataProvider: CoreDataProviderProtocol = CoreDataProvider() ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider
    }
    
    func saveHeroes(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.apiProvider.getHeroes(token: self.token) { [weak self] result in
                switch result {
                case .success(let heroes):
                    DispatchQueue.main.async {
                        self?.heroes = heroes
                        self?.coreDataProvider.deleteAllHeroes()
                        self?.heroes.forEach { self?.coreDataProvider.saveHeroDAO(hero: $0)}
                        self?.heroesDAO = self?.coreDataProvider.loadHeroesDAO() ?? []
                        completion()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func saveLocations(heros: HeroesDAO, completion: @escaping () -> Void)  {
        coreDataProvider.deleteAllLocations()
        DispatchQueue.global().async {
            var locationsCount = heros.count
            for hero in heros {
                self.apiProvider.getLocations(token: self.token, heroID: hero.id) { [weak self] result in
                    switch result {
                    case .success(let locations):
                        DispatchQueue.main.async {
                            self?.locations = locations
                            self?.locations.forEach{self?.coreDataProvider.saveLocationDAO(location: $0)}
//                            self?.locationsDAO = self?.coreDataProvider.loadLocationsDAO() ?? []
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    self?.locationsDAO = self?.coreDataProvider.loadLocationsDAO() ?? []
                    locationsCount -= 1
                    if locationsCount == 0 {
                        completion()
                    }
                }
                
                // Incluir notification center
            }
        }
    }
}
