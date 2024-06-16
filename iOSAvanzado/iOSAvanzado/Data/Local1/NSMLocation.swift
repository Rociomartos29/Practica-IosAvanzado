//
//  NSMLocation+CoreDataClass.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 3/3/24.
//
//

import Foundation
import CoreData

@objc(NSMLocation)
public class NSMLocation: NSManagedObject {

}

extension NSMLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSMLocation> {
        return NSFetchRequest<NSMLocation>(entityName: "NSMLocation")
    }

    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var heroes: NSMSuperHeros?

}

extension NSMLocation : Identifiable {

}

