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
           let container = NSPersistentContainer(name: "Model1")
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
       
       // Insertar héroes
       func insert(heroes: [Heroes]) {
           context.performAndWait {
               for hero in heroes {
                   let newHero = NSMSuperHeros(context: context)
                   newHero.id = hero.id
                   newHero.name = hero.name
                   newHero.descripcion = hero.descripcion
                   newHero.photo = hero.photo
                   newHero.favorito = hero.favorito
                   
                   // Guardar el contexto después de insertar cada héroe
                   saveContext()
               }
           }
       }
       
       // Insertar localizaciones asociadas a un héroe
       func storeLocations(_ locations: [Location], forHero idHeroe: String) {
           context.performAndWait {
               let fetchRequest: NSFetchRequest<NSMSuperHeros> = NSMSuperHeros.fetchRequest()
               fetchRequest.predicate = NSPredicate(format: "id == %@", idHeroe)
               
               do {
                   guard let hero = try context.fetch(fetchRequest).first else {
                       print("No se encontró ningún héroe con ID: \(idHeroe)")
                       return
                   }
                   
                   for location in locations {
                       let locationEntity = NSMLocation(context: context)
                       locationEntity.id = location.id
                       locationEntity.latitude = location.latitude
                       locationEntity.longitude = location.longitude
                       locationEntity.heroes = hero // Establecer la relación con el héroe
                   }
                   
                   // Guardar el contexto después de insertar todas las localizaciones
                   saveContext()
               } catch {
                   print("Error fetching hero with ID \(idHeroe): \(error)")
               }
           }
       }
       
       // Insertar transformaciones asociadas a un héroe
       func insert(transformaciones: [Transformaciones]) {
           context.performAndWait { [self] in
               for transformation in transformaciones {
                          // Asegurarse de que el ID del héroe sea opcional
                          guard let heroId = transformation.id else {
                              print("Transformación sin ID de héroe")
                              continue
                          }
                   
                   let fetchRequest: NSFetchRequest<NSMSuperHeros> = NSMSuperHeros.fetchRequest()
                   fetchRequest.predicate = NSPredicate(format: "id == %@", heroId)
                   
                   do {
                       guard let hero = try context.fetch(fetchRequest).first else {
                           print("No se encontró ningún héroe con ID: \(heroId)")
                           continue
                       }
                       
                       let transform = NSMTransformaciones(context: context)
                       transform.id = transformation.id
                       transform.name = transformation.name
                       transform.descripcion = transformation.descripcion
                       transform.photo = transformation.photo
                       transform.heroe = hero // Establecer la relación con el héroe
                   } catch {
                       print("Error fetching hero with ID \(heroId): \(error)")
                   }
               }
               
               // Guardar el contexto después de insertar todas las transformaciones
               saveContext()
           }
       }
       
       // Fetch de todos los héroes
       func fetchSuperheroes(filter: NSPredicate? = nil, sorting: [NSSortDescriptor]? = nil) -> [NSMSuperHeros] {
           let fetchRequest: NSFetchRequest<NSMSuperHeros> = NSMSuperHeros.fetchRequest()
           fetchRequest.predicate = filter
           fetchRequest.sortDescriptors = sorting
           
           do {
               let superheroes = try context.fetch(fetchRequest)
               return superheroes
           } catch {
               print("Error fetching superheroes: \(error)")
               return []
           }
       }
       
       // Fetch de todas las transformaciones
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
       
       // Fetch de todas las localizaciones
       func fetchLocation() -> [NSMLocation] {
           let fetchRequest: NSFetchRequest<NSMLocation> = NSMLocation.fetchRequest()
           
           do {
               let locations = try context.fetch(fetchRequest)
               return locations
           } catch {
               print("Error fetching locations: \(error)")
               return []
           }
       }
       
       // Guardar el contexto
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
