//
//  MapViewModelTests.swift
//  WeatherApplicationTests
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import XCTest
import MapKit
@testable import WeatherApplication

final class MapViewModelTests: XCTestCase {

    var systemUnderTest: MapViewModel!
    var mockDelegate = MockMapViewDelegate()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        systemUnderTest = MapViewModel(delegate: mockDelegate)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        systemUnderTest = nil
    }

    func testThatConfigureAnnotationsWhenNoData() {
        UserDefault.removeFavouriteList()
        
        systemUnderTest.configureAnnotations()
        XCTAssertTrue(mockDelegate.fitAnnotation)
    }
    
    func testThatConfigureAnnotationsWhenDataAvailable() {
        UserDefault.setFavouriteList(model: MockData.favouriteItemData)
        
        systemUnderTest.configureAnnotations()
        XCTAssertTrue(mockDelegate.addAnnotation)
    }

}

class MockMapViewDelegate: MapViewDelegate {
    var fitAnnotation: Bool = false
    var addAnnotation: Bool = false
    
    func addAnnotations(annotation: MKPointAnnotation) {
        addAnnotation = true
    }
    
    func zoomMapToFitAnnotation() {
        fitAnnotation = true
    }
    
}
