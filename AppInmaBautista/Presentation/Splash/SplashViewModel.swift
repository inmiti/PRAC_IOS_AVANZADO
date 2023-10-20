//
//  SplashViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

class SplashViewModel: SplashViewControllerDelegate {
    
    var viewState: ((SplashViewState) -> Void)?
    
    private var isToken: Bool {
        // TODO: Añadir si no hay token es false
        return true
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            self.viewState?(.navigateToLogin)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//            self.viewState?(.navigateToLogin)
//            // TODO: Añadir si hay token se navega a heroes si no hay token se navega a login
//        }
    }
}
