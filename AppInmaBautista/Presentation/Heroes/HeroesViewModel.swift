//
//  HeroesViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import Foundation
import CoreData

class HeroesViewModel: HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)?
    var heroes: Heroes = []
    var heroesCount: Int {
        heroes.count
    }
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(apiProvider: apiProvider, secureDataProvider: secureDataProvider)
    }
    
    private var apiProvider: ApiProviderProtocol
    private var secureDataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func loadData()  {
        // TODO: Ver si hay datos en coredata, si no...
        DispatchQueue.global().async {
            guard let token = self.secureDataProvider.getToken() else {return}
            self.apiProvider.getHeroes(token: token) { [weak self] result in
                switch result {
                    case .success(let heroes):
                        self?.heroes = heroes
                        //TODO: PRIMERO DELETE Y DESPUES: Guardar en CoreData
                    
                        self?.viewState?(.updateData)
                    case .failure(let error):
                        print("Error: \(error)")
                }
            }
        }
    }
    
    func heroBy(index: Int) -> Hero? {
        guard index >= 0 && index < heroesCount else {
            return nil
        }
        return heroes[index]
    }
    
    func logOut() {
        guard (secureDataProvider.getToken()) != nil else {
            return
        }
        secureDataProvider.deleteToken()
        viewState?(.navigateToLogin)
    }
}
