//
//  LoginModel.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 24/2/24.
//

import Foundation
enum LoginState {
    case loading
    case success
    case failed
}

class LoginViewModel{
    var loginState: ((LoginState) -> Void)?
       private let dragonBallApi: DragonBallApiProvider
       private let secureDataProvider: SecureDataProtocol
       
       init(dragonBallApi: DragonBallApiProvider = DragonBallApiProvider(),
            secureDataProvider: SecureDataProtocol = SecureDataKeychain()) {
           self.dragonBallApi = dragonBallApi
           self.secureDataProvider = secureDataProvider
       }
       
    func login(email: String, password: String) {
            self.loginState?(.loading)
        dragonBallApi.login(user: email, pass: password) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.loginState?(.success)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.loginState?(.failed)
                        debugPrint(error.localizedDescription)
                    }
               }
           }
       }
    func isLoggedIn() -> Bool {
            // Verificar si hay un token almacenado
            return secureDataProvider.getToken() != nil
        }
}
