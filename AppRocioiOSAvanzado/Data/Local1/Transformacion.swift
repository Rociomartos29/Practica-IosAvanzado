//
//  Transformacion+CoreDataClass.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 3/3/24.
//
//

import Foundation
import CoreData

@objc(NSMTransformaciones)
public class NSMTransformaciones: NSManagedObject {

}
extension NSMTransformaciones {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSMTransformaciones> {
        return NSFetchRequest<NSMTransformaciones>(entityName: "NSMTransformaciones")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var photo: String?
    @NSManaged public var heroe: NSMSuperHeros?

}

extension NSMTransformaciones : Identifiable {

}
