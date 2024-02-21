//
//  SearchListViewModelTests.swift
//  WeatherApplicationTests
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import XCTest
@testable import WeatherApplication

final class SearchListViewModelTests: XCTestCase {
    
    private var systemUnderTest: SearchListViewModel!
    private let mockDelegate = MockSearchListDelegate()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        systemUnderTest = SearchListViewModel(delegate: mockDelegate)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        systemUnderTest = nil
    }
    
    func testFetchPlacesListSuccessfully() {
        let expectation = expectation(description: "Fetch place successfully")
        let placeName = "joburg"
        systemUnderTest.fetchPlacesList(placeName)
        systemUnderTest.client.fetchPlace(name: placeName) { response, error in
            expectation.fulfill()
            XCTAssertEqual(response?.results.first?.place_id, "ChIJUWpA8GgMlR4RQUDTsdnJiiM")
            XCTAssertEqual(response?.results.first?.name, "Johannesburg")
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFetchPlacesDetailsSuccessfully() {
        let expectation = expectation(description: "Fetch place details successfully")
        let placeid = "ChIJUWpA8GgMlR4RQUDTsdnJiiM"
        
        systemUnderTest.client.fetchPlaceDetails(placeID: placeid) { response, error in
            expectation.fulfill()
        }
        
        XCTAssertNotNil(systemUnderTest.displayPlaces)
        waitForExpectations(timeout: 5)
    }
}

final class MockSearchListDelegate: SearchListViewModelDelegate {
    
    var reloadTable = false
    
    func reloadTableView() {
        reloadTable = true
    }
}
