//
//  SaveLocations.swift
//  AppInmaBautista
//
//  Created by ibautista on 27/10/23.
//

import Foundation

// MARK: - Protocol -
protocol SaveDataFromApiProtocol {
    func saveHeroes(completion: @escaping () -> Void)
    func saveLocations(hero: HeroDAO, completion: @escaping () -> Void)
}

class SaveDataFromApi: SaveDataFromApiProtocol {
    // MARK: - Properties -
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
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol = ApiProvider(),
         secureDataProvider: SecureDataProviderProtocol = SecureDataProvider(),
         coreDataProvider: CoreDataProviderProtocol = CoreDataProvider() ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider
    }
    
    // MARK: - Functions -
    func saveHeroes(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.apiProvider.getHeroes(token: self.token) { [weak self] result in
                switch result {
                case .success(let heroes):
                    DispatchQueue.main.async {
                        self?.heroes = heroes
                        self?.coreDataProvider.deleteAllHeroes()
                        self?.heroes.forEach {self?.coreDataProvider.saveHeroDAO(hero: $0)}
                        self?.heroesDAO = self?.coreDataProvider.loadHeroesDAO() ?? []
                        completion()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func saveLocations(hero: HeroDAO, completion: @escaping () -> Void)  {
        DispatchQueue.global().async {
                self.apiProvider.getLocations(token: self.token, heroID: hero.id ) { [weak self] result in
                    switch result {
                        case .success(let locations):
                            DispatchQueue.main.async {
                                self?.locations = locations
                                self?.locations.forEach{self?.coreDataProvider.saveLocationDAO(location: $0)}
                                completion()
                            }
                        case .failure(let error):
                            print("Error: \(error)")
                    }
                }
            }
        }
    }
