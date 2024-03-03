//
//  SplashViewController.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 24/2/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    private var secureData: SecureDataProtocol
    private var login: LoginViewController
    
    
    init( secureData: SecureDataProtocol = SecureDataKeychain(), login: LoginViewController) {
        self.secureData = secureData
        self.login = login
        super.init(nibName: String(describing: SplashViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.pushViewController(login, animated: true)
    }
}
