//
//  LoginViewController.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 24/2/24.
//

import UIKit

class LoginViewController: UIViewController {
    let secureDataProtocol = SecureDataKeychain()
    let login: LoginViewModel
  

    
    
    init(login: LoginViewModel = LoginViewModel()) {
           self.login = login
           
           super.init(nibName: String(describing: LoginViewController.self), bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Contraseña: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setObservers()
        navigationController?.isNavigationBarHidden = true
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        do {
            guard let email = Email.text, !email.isEmpty,
                  let password = Contraseña.text, !password.isEmpty else {
                // Mostrar mensaje de error si los campos están vacíos
                return
            }
            
            login.login(email: email, password: password)

            }
        }
    private func setObservers() {
        login.loginState = { [weak self] status in
            switch status {
                
            case .success:
                DispatchQueue.main.async {
                     let heroListController = HeroeListController(nibName: "HeroeListController", bundle: nil)
                           self?.navigationController?.pushViewController(heroListController, animated: true)
                       
                   }
                
            case .failed:
                print("Error")
                // Mostrar mensaje de error al usuario si lo deseas
            case .loading:
                print("Cargando")
            }
        }
    }

}

