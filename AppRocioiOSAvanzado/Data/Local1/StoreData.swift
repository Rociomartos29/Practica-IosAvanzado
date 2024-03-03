//
//  StoreData.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 28/2/24.
//

import Foundation
import CoreData

class StoreDataProvider {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Fetch Operations
    func insert (heroes: [Heroes]){
        context.performAndWait {
                   for heroe in heroes {
                       let newHeroe = NSMSuperHeros(context: context) // Corregimos el nombre de la entidad
                       newHeroe.id = heroe.id
                       newHeroe.name = heroe.name
                       newHeroe.descripcion = heroe.descripcion
                       newHeroe.photo = heroe.photo
                       newHeroe.favorito = heroe.favorito
                   }
                   self.saveContext()
               }
           }
    func storeLocations(_ locations: [Location], forHero idHeroe: String) {
        for location in locations {
            let locationEntity = NSMLocation(context: context)
            locationEntity.id = location.id
            locationEntity.latitude = location.latitude
            locationEntity.longitude = location.longitude
            
            
            self.saveContext()
        }
    }
    func insert (transformaciones: [Transformaciones]){
        context.performAndWait {
                   for heroe in transformaciones {
                       let transform = NSMSuperHeros(context: context) // Corregimos el nombre de la entidad
                       transform.id = heroe.id
                       transform.name = heroe.name
                       transform.descripcion = heroe.descripcion
                       transform.photo = heroe.photo
                       
                   }
                   self.saveContext()
               }
           }
    func fetchSuperheroes(filter: NSPredicate? = nil, sorting: [NSSortDescriptor]? = nil ) -> [NSMSuperHeros] {
        let fetchRequest: NSFetchRequest<NSMSuperHeros> = NSMSuperHeros.fetchRequest()
        do {
            let superheroes = try context.fetch(fetchRequest)
            return superheroes
        } catch {
            print("Error fetching superheroes: \(error)")
            return []
        }
    }
    
    func fetchTransformations() -> [NSMTransformaciones] {
        let fetchRequest: NSFetchRequest<NSMTransformaciones> = NSMTransformaciones.fetchRequest()
        do {
            let transformations = try context.fetch(fetchRequest)
            return transformations
        } catch {
            print("Error fetching transformations: \(error)")
            return []
        }
    }
    func fetchLocation() -> [NSMLocation] {
        let fetchRequest: NSFetchRequest<NSMLocation> = NSMLocation.fetchRequest()
        do {
            let location = try context.fetch(fetchRequest)
            return location
        } catch {
            print("Error fetching locatios: \(error)")
            return []
        }
    }
    func saveContext() {
        if context.hasChanges {
            do {
               try context.save()
            } catch {
                context.rollback()
                debugPrint("Error saving changes in BBDD")
            }
        }
    }
}
