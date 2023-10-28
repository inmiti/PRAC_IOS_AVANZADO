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
    private let saveDataFromApi: SaveDataFromApiProtocol
    
    init(heroes: HeroesDAO,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProviderProtocol,
         saveDataFromApi: SaveDataFromApiProtocol = SaveDataFromApi()
    ) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.heroes = heroes
        self.coreDataProvider = coreDataProvider
        self.saveDataFromApi = saveDataFromApi
    }
    
    func onViewAppear() {
        viewState?(.loading)
//        for hero in heroes{
//            apiRequest(hero: hero) {[weak self] in
//                self?.locations.append(contentsOf: locations)
//            }
//        }
//            self.viewState?(.updatedData(locations: self.locations ?? []) )
        }
       
        
//        for hero in heroes {
//            apiRequest(hero: hero) {[weak self] in
//                self?.locations.append(contentsOf: self?.locations ?? [])
//            }
//        }
//        DispatchQueue.main.async {
//            self.viewState?(.updatedData(locations: self.locations) )
//        }
    }
    
//    private func apiRequest(hero: HeroDAO, completion: @escaping () -> Void) {
////        coreDataProvider.deleteAllLocations()
//        guard let token = secureDataProvider.getToken() else {return}
////        for hero in heroes {
//            DispatchQueue.global().async {
//
//                self.apiProvider.getLocations(token: token, heroID: hero.id) { [weak self] result in
//                    switch result {
//                        case .success(let locations):
//                            DispatchQueue.main.async {
//                                self?.locations.append(contentsOf: locations)
//                                completion()
//
//                            }
//                        case .failure(let error):
//                            print("Error: \(error)")
//                    }
//                }
//            }
////        }
//    }
//}
