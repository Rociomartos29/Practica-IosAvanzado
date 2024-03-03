//
//  HeroCell.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 28/2/24.
//

import UIKit

class HeroCell: UITableViewCell {
    
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupConstraints() {
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            heroImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            heroImage.widthAnchor.constraint(equalToConstant: 180),
            heroImage.heightAnchor.constraint(equalToConstant: 180)
        ])

        heroName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heroName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heroName.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor, constant: 8), // Corrige el leading
            heroName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heroName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            heroName.widthAnchor.constraint(equalToConstant: 180) // Establece un ancho fijo para heroName
        ])
        }
    func configure(with hero: NSMSuperHeros){
       
        if let urlImage = hero.photo {
                heroImage.setImage(url: urlImage)
            } else {
                // Manejar el caso donde hero.photo es nil
                // Por ejemplo, puedes configurar una imagen predeterminada
            }
        heroName.text = hero.name
    }
}

extension UIImageView {
    func load(from url: URL, completion: @escaping () -> Void) {
        print("Loading image from URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    print("Error loading image from URL: \(url)")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    print("Error creating image from data")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
                print("Image loaded successfully")
                completion() // Llamada al bloque de finalización
            }
        }.resume()
    }
    private func downloadWithURLSession(url:URL, completion: @escaping (UIImage?) -> Void){
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, _ in
            guard let data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        .resume()
    }
    
    
    func setImage(url:String){
        guard let urlString = URL(string: url) else { return }
        
        downloadWithURLSession(url: urlString) { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.image = image
                } else {
                    // En caso de que la imagen sea nil, puedes configurar una imagen predeterminada
                    self?.image = UIImage(named: "default_hero_image")
                }
            }
        }
    }
}
