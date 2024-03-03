//
//  HeroesController.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 24/2/24.
//

import UIKit
import Kingfisher
import MapKit
class HeroesController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var imageFondo: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var transformacione: [Transformaciones] = []
        var viewModel: HeroDetailViewModel?
        var hero: [NSMSuperHeros] = []
        
    override func viewDidLoad() {
            super.viewDidLoad()
        mapView.delegate = self
               // Verificar si viewModel no es nil antes de cargar los datos
               if viewModel != nil {
                   viewModel?.loadData()
               }
               viewModel?.stateChanged = { [weak self] state in
                   if state == .updated {
                       self?.configureUI()
                       // Llamar a configureCollectionView() después de cargar los datos
                       self?.configureCollectionView()
                   }
               }
           }


    private func configureUI() {
        if let viewModel = viewModel {
                   nameLabel.text = viewModel.getHeroName() ?? "Nombre no disponible"
                   descriptionLabel.text = viewModel.getHeroDescription() ?? "Descripción no disponible"
                   mapView.removeAnnotations(mapView.annotations)
                   let locations = viewModel.getHeroLocations()
                   for location in locations {
                       if let latitude = Double(location.latitude ?? ""),
                          let longitude = Double(location.longitude ?? "") {
                           let annotation = MKPointAnnotation()
                           annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                           mapView.addAnnotation(annotation)
                       }
                   }
                   if let firstLocation = locations.first,
                      let latitude = Double(firstLocation.latitude ?? ""),
                      let longitude = Double(firstLocation.longitude ?? "") {
                       let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                       let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
                       mapView.setRegion(region, animated: true)
                   }
                   transformacione = viewModel.getHeroTransformations()?.map { Transformaciones(name: $0.name!, id: $0.id!, descripcion: $0.description, photo: $0.photo!) } ?? []
                   print("Número de transformaciones: \(transformacione.count)")
                   collectionView.reloadData()
               }
           }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "locationAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            annotationView!.image = UIImage(named: "locationLogo")
            annotationView!.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            return annotationView
        }

        @IBAction func backButtonTapped(_ sender: UIButton) {
            navigationController?.popViewController(animated: true)
        }
    }

extension HeroesController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    private func configureCollectionView() {
         // Asegúrate de llamar a configureCollectionView en el hilo principal
         DispatchQueue.main.async {
             self.collectionView.dataSource = self
             self.collectionView.delegate = self
             let nib = UINib(nibName: "TransformacionesCell", bundle: nil)
             self.collectionView.register(nib, forCellWithReuseIdentifier: "TransformacionesCell")
             self.collectionView.reloadData()
         }
     }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Número de elementos en la sección: \(transformacione.count)")
        return transformacione.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformacionesCell", for: indexPath) as? TransformacionesCell else {
            return UICollectionViewCell()
        }
        
        // Verifica que los datos de transformación no estén vacíos antes de configurar la celda
        if let transformations = viewModel?.getHeroTransformations() {
            let currentTransformation = transformations[indexPath.item]
            cell.configure(with: currentTransformation)
        }
        
        return cell
    }
}
