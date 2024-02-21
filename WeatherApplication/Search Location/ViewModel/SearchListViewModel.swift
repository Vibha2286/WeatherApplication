//
//  SearchListViewModel.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import Foundation

protocol SearchListViewModelDelegate: AnyObject {
    
    func reloadTableView()
}

final class SearchListViewModel {
    
    let client = PlacesAPIClient()
    private weak var delegate: SearchListViewModelDelegate?
    private(set) var displayPlaces = [PlaceDetailsModel]()
    private(set) var cityName = ""

    // MARK: Initialisation

    /// Initialize view and array
    /// - Parameter view: SearchListViewModelDelegate view
    init(delegate: SearchListViewModelDelegate) {
        self.delegate = delegate
    }

    func fetchPlacesList(_ name: String) {
        client.fetchPlace(name: name) { [weak self] response, error in
            guard let placeId = response?.results.first?.place_id else { return }
            self?.fetchPlacesDetails(placeId)
         }
      }

    func fetchPlacesDetails(_ placeID: String) {
        client.fetchPlaceDetails(placeID: placeID) { [weak self] response, error in
            guard let self = self, let response = response else { return }
            self.displayPlaces.append(response)
            self.delegate?.reloadTableView()
       }
    }
}
