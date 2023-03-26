//
//  APIError.swift
//  FFLASHH
//
//  Created by Moca Girges on 22/05/2021.
//

import Foundation

enum APIError: Error, Equatable {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case FlagFound(error: String)
    case unauthenticated
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Please check your connection and try again later"
        case .invalidData:
            return "Invalid Data"
        case .responseUnsuccessful:
            return "Response Unsuccessful"
        case .jsonParsingFailure:
            return "JSON Parsing Failure"
        case .jsonConversionFailure:
            return "JSON Conversion Failure"
        case .FlagFound(let error):
            return error
        case .unauthenticated:
            return "unauthenticated user"
        }
    }
}
