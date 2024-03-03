//
//  anotations.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 3/3/24.
//

import Foundation
import MapKit

class Annotations: NSObject, MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var id: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, id: String? = nil){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.id = id
    }
}

class Annotation: MKAnnotationView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setUpUI()
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        backgroundColor = .clear
        let image = UIImage.init(named: "locationLogo")
        let imageView = UIImageView.init(image: image)
        addSubview(imageView)
    }
}
