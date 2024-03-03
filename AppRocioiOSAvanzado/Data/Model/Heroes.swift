//
//  File.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 1/3/24.
//

import Foundation
struct Heroes: Codable{
    var name: String
    var id: String
    var descripcion: String
    var photo: String
    var favorito: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case descripcion = "description"
        case photo
        case favorito = "favorite"
        
    }
    
}
struct Detalles:Decodable{
    let id: String
    let name: String
    let description:String
    let photo: String
    let favorite: Bool
    let transformacion: Transformaciones
    let location: Location
    
}
       
