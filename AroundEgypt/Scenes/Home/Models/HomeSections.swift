//
//  HomeSections.swift
//  AroundEgypt
//
//  Created by Monica Girgis Kamel on 24/03/2023.
//

import Foundation

enum HomeSections {
    case welcome
    case recommened
    case recent
    
    var title: String? {
        switch self {
        case .welcome:
            return "Welcome!"
        case .recommened:
            return "Recommended Experiences"
        case .recent:
            return "Most Recent"
        }
    }
}
