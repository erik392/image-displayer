//
//  LandingViewModel_Tests.swift
//  image-displayerTests
//
//  Created by Erik Egers on 2025/05/19.
//

import SwiftUI
import PhotosUI
import XCTest
@testable import image_displayer

@MainActor
final class LandingViewModel_Tests: XCTestCase {
    
    private var viewModelUnderTest: LandingViewModel!
    private var mockImageLoader: MockImageLoader!

    override func setUpWithError() throws {
        mockImageLoader = MockImageLoader()
        viewModelUnderTest = LandingViewModel(imageLoader: mockImageLoader)
    }

    override func tearDownWithError() throws {
        viewModelUnderTest = nil
        mockImageLoader = nil
    }

    func testClearErrorSetsErrorToNil() throws {
        viewModelUnderTest.imageLoadingError = "Sample Error"
        viewModelUnderTest.clearError()
        XCTAssert(viewModelUnderTest.imageLoadingError == nil)
    }
    
    func testLoadImageWithSucces() {
        mockImageLoader.shouldSucceed = true
        let expectation = XCTestExpectation(description: "Image load suceeded")
        
        // We are testing an async function with a sync test, therefore we need to ensure we make our assertions after the property has been updated.
        let image = viewModelUnderTest.$selectedImage
                .dropFirst() // Ignores the initial value
                .sink { _ in
                    expectation.fulfill() //Indicates that the image loader has executed and updated values
                }
        
        viewModelUnderTest.photosPickerItem = PhotosPickerItem(itemIdentifier: "Test")
        
        // We give it some time, and if nothing happens after 1 second, then the test fails.
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModelUnderTest.selectedImage, UIImage(systemName: "checkmark"))
        XCTAssertNil(viewModelUnderTest.photosPickerItem)
        XCTAssertFalse(viewModelUnderTest.showErrorAlert)
        XCTAssertNil(viewModelUnderTest.imageLoadingError)
    }
    
    func testLoadImageWithFaliure() {
        mockImageLoader.shouldSucceed = false
        let expectation = XCTestExpectation(description: "Image load failed")
        
        let error = viewModelUnderTest.$imageLoadingError
                .dropFirst()
                .sink { _ in
                    expectation.fulfill()
                }
        
        viewModelUnderTest.photosPickerItem = PhotosPickerItem(itemIdentifier: "Test")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModelUnderTest.selectedImage, UIImage(named: "placeholderImage"))
        XCTAssertEqual(viewModelUnderTest.imageLoadingError, "Image loading failed: Test Error")
        XCTAssertNil(viewModelUnderTest.photosPickerItem)
    }
    
    
    class MockImageLoader: ImageLoading {
        
        var shouldSucceed = true

        func loadImage(from item: PhotosPickerItem) async throws -> UIImage {
            if shouldSucceed {
                return UIImage(systemName: "checkmark")!
            } else {
                throw TestError()
            }
            
        }
    }
    
    struct TestError: LocalizedError {
        
        var errorDescription: String? { "Test Error" }
    }

}
