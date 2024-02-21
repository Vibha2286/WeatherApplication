//
//  SearchLocationViewController.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import UIKit

final class SearchLocationViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var onLocationSelected: ((Location) -> Void)!
    
    private lazy var viewModel = SearchListViewModel(delegate: self)
    private let searchViewcontroller = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureUI() {
        searchViewcontroller.searchResultsUpdater = self
        navigationItem.searchController = searchViewcontroller
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) { }
}

// MARK: UISearchResultsUpdating

extension SearchLocationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.fetchPlacesList(text)
    }
}

// MARK: Tableview delegate method

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayPlaces.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.displayPlaces[indexPath.row]
        cell.updateUI(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popToRootViewController(animated: true)
        let details = viewModel.displayPlaces[indexPath.row]
        onLocationSelected?(details.result.geometry.location)
    }
}

extension SearchLocationViewController: SearchListViewModelDelegate {
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
