//
//  HeroesViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import Foundation

class HeroesViewModel: HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)?
    var heroes: Heroes = []
    var heroesCount: Int {
        heroes.count
    }
    
    private var apiProvider: ApiProviderProtocol
    private var secureDataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func loadData()  {
        let token = secureDataProvider.getToken()
        apiProvider.getHeroes(token: token) { [weak self] result in
            DispatchQueue.global().async {
                switch result {
                    case .success(let heroes):
                        self?.heroes = heroes
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
}
