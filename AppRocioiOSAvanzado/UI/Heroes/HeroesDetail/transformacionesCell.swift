//
//  transformacionesCell.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 3/3/24.
//

import UIKit

class TransformacionesCell: UICollectionViewCell {

    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with transformation: NSMTransformaciones) {
        heroName.text = transformation.name
        let imageUrl = transformation.photo
        // Cargar la imagen desde la URL utilizando Kingfisher o cualquier otra biblioteca de carga de imágenes
        heroImage.kf.setImage(with: URL(string: imageUrl!))
        
    }
}
