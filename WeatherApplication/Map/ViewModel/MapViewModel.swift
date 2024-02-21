//
//  MapViewModel.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/18.
//

import Foundation
import MapKit

protocol MapViewDelegate: AnyObject {
    
    func addAnnotations(annotation: MKPointAnnotation)
    func zoomMapToFitAnnotation()
}

final class MapViewModel {
    
    private weak var delegate: MapViewDelegate?
    var locationDetails = [CurrentWeatherOffline]()
    
    init(delegate: MapViewDelegate) {
        self.delegate = delegate
        self.locationDetails = UserDefault.getFavouriteList()
    }
    
    /// Configure annotations from the data array
    func configureAnnotations() {
        for object in locationDetails {
            let annotation = MKPointAnnotation()
            annotation.title = object.current?.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: object.latitude ?? 0.0, longitude: object.longitude ?? 0.0)
            delegate?.addAnnotations(annotation: annotation)
        }
        delegate?.zoomMapToFitAnnotation()
    }
}
