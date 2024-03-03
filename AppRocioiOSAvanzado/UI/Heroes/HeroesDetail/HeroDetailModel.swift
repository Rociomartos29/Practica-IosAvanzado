//
//  HeroDetailModel.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 1/3/24.
//

import Foundation
enum HeroDetailState {
    case updated
}
class HeroDetailViewModel {
    private let hero: NSMSuperHeros
    private var locations: [Location] = []
    private var storeDataProvider: StoreDataProvider
    private var apiProvider: DragonBallApiProvider // Propiedad añadida

    var stateChanged: ((HeroDetailState) -> Void)?
    deinit {
        removeObservers()
    }
    
    // Inicializador
    init(hero: NSMSuperHeros, apiProvider: DragonBallApiProvider, storeDataProvider: StoreDataProvider = StoreDataProvider()) {
        self.hero = hero
        self.apiProvider = apiProvider // Inicializar la propiedad apiProvider
        self.storeDataProvider = storeDataProvider
    }

    // Método para cargar los datos del héroe
    func loadData() {
        guard let heroId = hero.id else {
            print("Error: Hero ID is nil")
            return
        }

        let nsmlLocations = storeDataProvider.fetchLocation()
        if !nsmlLocations.isEmpty {
            let locations = nsmlLocations.map { nsmlLocation -> Location in
                return Location(id: nsmlLocation.id, latitude: nsmlLocation.latitude, longitude: nsmlLocation.longitude)
            }

            self.locations = locations
            updatedData()
        } else {
            var error: DragonBallError?
            let group = DispatchGroup()
            group.enter()

            // Cargar las localizaciones del héroe desde la API
            loadLocationsForHero(id: heroId) { [weak self] result in
                switch result {
                case .success(let locations):
                    // Convertir las localizaciones de DBLocation a Location
                    let convertedLocations = locations.map { dbLocation -> Location in
                        return Location(id: dbLocation.id, latitude: dbLocation.latitude, longitude: dbLocation.longitude)
                    }
                    self?.locations = convertedLocations
                case .failure(let err):
                    error = err
                }
                group.leave()
            }

            // Notificar cuando se completen todas las tareas
            group.notify(queue: .main) {
                if let error = error {
                    // Manejar el error si lo hay
                    print("Error loading hero locations: \(error)")
                }
                self.updatedData() // Notificar que se han actualizado los datos
            }
        }
    }

    private func loadLocationsForHero(id: String, completion: @escaping (Result<[Location], DragonBallError>) -> Void) {
        apiProvider.getLocation(idHeroe: id) { result in
            completion(result)
        }
    }

    // Métodos para obtener información del héroe
    func getHeroName() -> String? {
        return hero.name
    }

    func getHeroDescription() -> String? {
        return hero.descripcion
    }

    func getHeroLocations() -> [Location] {
        return locations
    }

    func getHeroTransformations() -> [NSMTransformaciones]? {
        return hero.transformacion?.allObjects as? [NSMTransformaciones]
    }

    // Método privado para notificar cambios en el estado
    private func updatedData() {
        self.stateChanged?(.updated)
    }
    
    private func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
}

