//
//  FakeHomeRepo.swift
//  AroundEgyptTests
//
//  Created by Monica Girgis Kamel on 25/03/2023.
//

import Foundation
@testable import AroundEgypt

enum ResultState {
    case success
    case fail
}

final class FakeHomeRepo {
    
    var testCaseState: ResultState = .success
    let successModdel = Response(meta: GeneralStatus(code: 200, errors: []), data: [Experience(id: "id", title: "title", coverPhoto: "photo", description: "desc", viewsNo: 1, likesNo: 1, recommended: 2, isLiked: "true", detailedDescription: "test", address: "test")])
    
    func setTestCaseState(testCaseState: ResultState) {
        self.testCaseState = testCaseState
    }
    
    func getRecommendedData(completion: (Result< Response<[Experience]>, APIError>)->()){
        switch testCaseState {
            
        case .success:
            completion(.success(successModdel))
        case .fail:
            completion(.failure(.FlagFound(error: "error found")))
        }
    }
    
    func getRecentData(completion: (Result< Response<[Experience]>, APIError>)->()){
        switch testCaseState {
            
        case .success:
            completion(.success(successModdel))
        case .fail:
            completion(.failure(.FlagFound(error: "error found")))
        }
    }
    
    func getSearchData(completion: (Result< Response<[Experience]>, APIError>)->()){
        switch testCaseState {
            
        case .success:
            completion(.success(successModdel))
        case .fail:
            completion(.failure(.FlagFound(error: "error found")))
        }
    }
}


