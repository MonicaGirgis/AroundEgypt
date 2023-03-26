//
//  Baquala.swift
//  Baquala
//
//  Created by Monica Girgis Kamel on 24/03/2022.
//

import Foundation

enum AroundEgypt{
    case getExperiences(isRecommended: Bool? = nil, searchText: String? = nil)
    case getExperience(id: String)
    case likeExperience(id: String)
}

extension Bundle {
    var baseURL: String {
        return object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    }
    
    var urlSubFolder: String {
        return object(forInfoDictionaryKey: "URLSubFolder") as? String ?? ""
    }
}

extension AroundEgypt: Endpoint{
    var base: String {
        return Bundle.main.baseURL
    }
    
    var urlSubFolder: String {
        return Bundle.main.urlSubFolder
    }
    
    var path: String {
        switch self {
        case .getExperiences:
            return "experiences"
        case .getExperience(let id):
            return "experiences/\(id)"
        case .likeExperience(let id):
            return "experiences/\(id)/like"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .likeExperience:
            return .post
        default:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        switch self{
        case .getExperiences(let isRecommended, let searchText):
            if isRecommended ?? false {
                queryItems.append(URLQueryItem(name: "filter[recommended]", value: "true"))
            }
            
            if let searchText = searchText {
                queryItems.append(URLQueryItem(name: "filter[title]", value: searchText))
            }
            
            return queryItems
            
        default:
            return queryItems
        }
        
    }
    
    var body: [String: Any]?{
        return nil
    }
    
    var headers : [httpHeader] {
        return []
    }
}

extension URLRequest{
    mutating func addHeaders(_ Headers:[httpHeader]){
        for Header in Headers {
            self.addValue(Header.value, forHTTPHeaderField: Header.key)
        }
    }
}
