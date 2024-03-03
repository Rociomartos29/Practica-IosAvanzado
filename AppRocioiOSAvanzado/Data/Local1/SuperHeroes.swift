//
//  SuperHeroes+CoreDataClass.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 3/3/24.
//
//

import Foundation
import CoreData

@objc(NSMSuperHeros)
public class NSMSuperHeros: NSManagedObject {

}
extension NSMSuperHeros {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSMSuperHeros> {
        return NSFetchRequest<NSMSuperHeros>(entityName: "NSMSuperHeros")
    }

    @NSManaged public var name: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var id: String?
    @NSManaged public var photo: String?
    @NSManaged public var favorito: Bool
    @NSManaged public var transformacion: NSSet?
    @NSManaged public var location: Set<NSMLocation>?

}

// MARK: Generated accessors for transformacion
extension NSMSuperHeros {

    @objc(addTransformacionObject:)
    @NSManaged public func addToTransformacion(_ value: NSMTransformaciones)

    @objc(removeTransformacionObject:)
    @NSManaged public func removeFromTransformacion(_ value: NSMTransformaciones)

    @objc(addTransformacion:)
    @NSManaged public func addToTransformaciones(_ values: NSSet)

    @objc(removeTransformacion:)
    @NSManaged public func removeFromTransformaciones(_ values: NSSet)

}

extension NSMSuperHeros : Identifiable {

}
