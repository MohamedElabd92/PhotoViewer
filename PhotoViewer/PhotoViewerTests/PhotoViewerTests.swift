//
//  PhotoViewerTests.swift
//  PhotoViewerTests
//
//  Created by Mohamed Elabd on 10/09/2021.
//

import XCTest
@testable import PhotoViewer

class PhotoViewerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testAddAdvertisementItems() {
        let vc = PhotosListViewController()
        
        // Add 10 items
        for _ in 1...10 {
            vc.photosData.append(PhotosModel())
        }
        
        // Add ads items
        vc.addAdvertisementItems()
        
        // Check for ads items
        XCTAssertTrue(vc.photosDataWithAds[5].isAdvertisementItem ?? false)
        XCTAssertTrue(vc.photosDataWithAds.last?.isAdvertisementItem ?? false)
    }
}
