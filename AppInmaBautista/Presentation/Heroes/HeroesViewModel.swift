//
//  HeroesViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit
import CoreData

class HeroesViewModel: HeroesViewControllerDelegate {
    // MARK: - Dependencies -
    private var apiProvider: ApiProviderProtocol
    private var secureDataProvider: SecureDataProviderProtocol
    private var coreDataProvider: CoreDataProviderProtocol
    private var saveDataFromApi: SaveDataFromApiProtocol
    
    // MARK: - Properties -
    var viewState: ((HeroesViewState) -> Void)?
    var heroes: Heroes = []
    var heroesDAO: [HeroDAO] = []
    var heroesCount: Int {
        heroesDAO.count
    }
    private var thereAreData: Bool {
        coreDataProvider.loadHeroesDAO().isEmpty == false
    }
    
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    
    var mapViewModel: MapViewControllerDelegate {
        MapViewModel(heroesDAO: heroesDAO,
                     apiProvider: apiProvider,
                     secureDataProvider: secureDataProvider,
                     coreDataProvider: coreDataProvider
        )
    }
    
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol,
         coreDataProvider: CoreDataProviderProtocol = CoreDataProvider(),
         saveDataFromApi: SaveDataFromApiProtocol = SaveDataFromApi()) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
        self.coreDataProvider = coreDataProvider
        self.saveDataFromApi = saveDataFromApi
        
    }
    
    // MARK: - Functions -
    func onViewAppear()  {
        if thereAreData {
                heroesDAO = coreDataProvider.loadHeroesDAO()
                viewState?(.updatedData)
            } else {
                saveDataFromApi.saveHeroes { [weak self] in
                    // La clausura se ejecuta cuando se ha completado saveHeroes
                    self?.heroesDAO = self?.coreDataProvider.loadHeroesDAO() ?? []
                    DispatchQueue.main.async {
                        self?.viewState?(.updatedData)
                    }
                }
        }
    }
    
    func heroBy(index: Int) -> HeroDAO? {
        guard index >= 0 && index < heroesCount else {
            return nil
        }
        return heroesDAO[index]
    }
    
    func logOut() {
        guard (secureDataProvider.getToken()) != nil else {
            return
        }
        secureDataProvider.deleteToken()
        guard thereAreData else {return}
        coreDataProvider.deleteAllHeroes()
        coreDataProvider.deleteAllLocations()
        viewState?(.navigateToLogin)
    }
    
    func detailViewModel(index: Int ) -> DetailViewControllerDelegate? {
        guard let selectedHero = heroBy(index: index) else { return nil }
        return DetailViewModel(
                hero: selectedHero,
                apiProvider: apiProvider,
                secureDataProvider: secureDataProvider)
    }
}
