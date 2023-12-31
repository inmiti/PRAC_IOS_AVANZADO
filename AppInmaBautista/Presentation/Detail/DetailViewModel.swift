//
//  DetailViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//

import Foundation

class DetailViewModel: DetailViewControllerDelegate {
    
    // MARK: - Dependencies -
    private let hero: HeroDAO
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    private let coreDataProvider: CoreDataProviderProtocol
    
    // MARK: - Properties -
    var viewState: ((DetailViewState) -> Void)?
    private var locations: Locations = []
    private var locationsDAO: LocationsDAO = []
    
    private var thereAreData: Bool {
        coreDataProvider.loadLocationsDAO().isEmpty == false
    }
    // MARK: - Initializers -
    init(hero: HeroDAO,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProviderProtocol) {
        self.hero = hero
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider
    }
    
    // MARK: - Public Functions -
    func onViewAppear() {
        viewState?(.loading(true))
        DispatchQueue.global().async {
            
            guard let token = self.secureDataProvider.getToken() else {return}

            self.apiProvider.getLocations(token: token,
                                          heroID: self.hero.id){ [weak self] result in
                switch result {
                case .success(let locations):
                    self?.locations = locations
                    self?.viewState?(.update(hero: self!.hero,
                                             locations: locations))
                    self?.viewState?(.loading(false))
                    
                case .failure(let error):
                    print("Error en llamada a localizaciones: \(error)")
                }
            }
        }
    }
}
