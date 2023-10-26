//
//  HeroesViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit
import CoreData

class HeroesViewModel: HeroesViewControllerDelegate {
    
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
        MapViewModel(heroes: heroes, apiprovider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    private var apiProvider: ApiProviderProtocol
    private var secureDataProvider: SecureDataProviderProtocol
    private var coreDataProvider = CoreDataProvider()
    
    
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onViewAppear()  {
        // TODO: Ver si hay datos en coredata, si no...
        thereAreData == true ? heroesDAO = coreDataProvider.loadHeroesDAO() : saveDataFromApi()
        viewState?(.updateData)
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
        viewState?(.navigateToLogin)
    }
        
    private func saveDataFromApi() {
        guard let token = self.secureDataProvider.getToken() else {return}
            DispatchQueue.global().async {
                self.apiProvider.getHeroes(token: token) { [weak self] result in
                    switch result {
                    case .success(let heroes):
                        DispatchQueue.main.async {
                            self?.heroes = heroes
                            self?.coreDataProvider.deleteAllHeroes()
                            self?.heroes.forEach { self?.coreDataProvider.saveHeroDAO(hero: $0)}
                            self?.heroesDAO = self?.coreDataProvider.loadHeroesDAO() ?? []
                            self?.viewState?(.updateData)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        }
        
}
