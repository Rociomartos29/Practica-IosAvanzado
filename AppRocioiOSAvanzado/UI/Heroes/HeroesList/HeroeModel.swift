//
//  HeroeModel.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 28/2/24.
//

import Foundation
import CoreData
enum HeroState {
    case loading
    case success
    case failed
}
class HeroListViewModel {
    var heroState: ((HeroState) -> Void)?
    var heroes: [NSMSuperHeros] = []
    var dataUpdated: (() -> Void)?
    
    private let apiProvider: DragonBallApiProvider
    private let storeDataProvider: StoreDataProvider
    deinit {
        removeObservers()
    }
    init(apiProvider: DragonBallApiProvider = DragonBallApiProvider(), storeDataProvider: StoreDataProvider = StoreDataProvider()) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
        self.addObservers()
    }
    
    func loadData() {
        heroes = storeDataProvider.fetchSuperheroes(sorting: sortDescriptor(ascending: false))
        if heroes.isEmpty {
            apiProvider.getSuperheroes { [weak self] result in
                switch result{
                case .success(let heroes):
                    self?.storeDataProvider.insert(heroes: heroes)
                case .failure(let error):
                    debugPrint("Error getting data in Heroes viewModel \(error)")
                }
            }
        }
    }
    
    
    
    func notifyDataUpdated() {
        DispatchQueue.main.async {
            self.dataUpdated?()
        }
    }
    
    func numOfHeroes() -> Int {
        return heroes.count
    }
    
    
    func parseHeroes(from json: [String: Any]) {
        guard let heroesData = json["heroes"] as? [[String: Any]] else {
            print("Error: No se encontró la clave 'heroes' en el JSON o su estructura no es la esperada")
            self.notifyState(.failed)
            return
        }
        
        var heroes: [NSMSuperHeros] = []
        
        for heroData in heroesData {
            guard let name = heroData["name"] as? String,
                  let id = heroData["id"] as? String,
                  let descripcion = heroData["descripcion"] as? String,
                  let photo = heroData["photo"] as? String,
                  let favorito = heroData["favorito"] as? Bool else {
                print("Error: Los datos de un héroe no son válidos o están incompletos")
                continue
            }
            
            let hero = NSMSuperHeros()
            heroes.append(hero)
        }
        
        self.heroes = heroes
        self.notifyDataUpdated()
    }


        private func sortDescriptor(ascending: Bool = true) -> [NSSortDescriptor] {
            let sort = NSSortDescriptor(keyPath: \NSMSuperHeros.name, ascending: ascending)
            return [sort]
        }

        private func addObservers() {
            NotificationCenter.default.addObserver(forName: NSManagedObjectContext.didSaveObjectsNotification, object: nil, queue: .main) { [weak self] _ in
                self?.loadData()
            }
        }

        private func notifyState(_ state: HeroState) {
            DispatchQueue.main.async {
                self.heroState?(state)
            }
        }
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
