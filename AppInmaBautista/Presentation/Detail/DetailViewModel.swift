//
//  DetailViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 25/10/23.
//

import Foundation

class DetailViewModel: DetailViewControllerDelegate {
    
    private var locations: Locations = []
    private let hero: HeroDAO
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    var viewState: ((DetailViewState) -> Void)?
    init(hero: HeroDAO,
         apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.hero = hero
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async {
            defer {self.viewState?(.loading(false))}
            guard let token = self.secureDataProvider.getToken() else {return}
            self.apiProvider.getLocations(token: token,
                                          heroID: self.hero.id){ [weak self] result in
                switch result {
                case .success(let locations):
                    self?.locations = locations
                    self?.viewState?(.update(hero: self!.hero,
                                             locations: locations))
                case .failure(let error):
                    print("Error en llamada a localizaciones: \(error)")
                }
            }
            
        }
    }
}
