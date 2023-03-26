//
//  HomViewModelTest.swift
//  AroundEgyptTests
//
//  Created by Monica Girgis Kamel on 25/03/2023.
//

import XCTest
@testable import AroundEgypt

final class HomViewModelTest: XCTestCase {

    var fakeHomeRepo: FakeHomeRepo!
    var homeViewModel: HomeViewModel!
    
    override func setUpWithError() throws {
        fakeHomeRepo = FakeHomeRepo()
        homeViewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        fakeHomeRepo = nil
        homeViewModel = nil
    }
    
    func testGetRecommendedData_ShouldReturnSuccess() {
        fakeHomeRepo.setTestCaseState(testCaseState: .success)
        fakeHomeRepo.getRecommendedData { ressult in
            
            switch ressult {
            case .success(let data):
                XCTAssertEqual(data.data.first?.id, "id")
            case .failure(_):
                break;
            }
            
        }
    }

}
