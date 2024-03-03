//
//  HeroeListController.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 28/2/24.
//

import UIKit
import CoreData

class HeroeListController: UIViewController {
    
    let heroListViewModel: HeroListViewModel = HeroListViewModel(apiProvider: DragonBallApiProvider())
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
            super.viewDidLoad()
            setupTableView()
            loadData()
        if traitCollection.userInterfaceStyle == .dark {
                tableView.backgroundColor = .black // Color de fondo oscuro
            } else {
                tableView.backgroundColor = .white // Color de fondo claro
            }
        }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Verificar si cambió el modo de interfaz
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // Actualizar el color de fondo adaptativo
            if traitCollection.userInterfaceStyle == .dark {
                tableView.backgroundColor = .black // Color de fondo oscuro
            } else {
                tableView.backgroundColor = .white // Color de fondo claro
            }
        }
    }
        private func setupTableView() {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "HeroCell", bundle: nil), forCellReuseIdentifier: "HeroCell")
        }

        private func loadData() {
            heroListViewModel.loadData()
        }
    }


extension HeroeListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroListViewModel.numOfHeroes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as? HeroCell else {
            return UITableViewCell()
        }
        let hero = heroListViewModel.heroes[indexPath.row]
        cell.configure(with: hero)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HeroeListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHero = heroListViewModel.heroes[indexPath.row]
                let heroDetailViewModel = HeroDetailViewModel(hero: selectedHero, apiProvider: DragonBallApiProvider())
        let heroDetailViewController = HeroesController()
                navigationController?.pushViewController(heroDetailViewController, animated: true)
            }
        }
