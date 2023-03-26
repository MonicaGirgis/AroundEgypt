//
//  APIHandler.swift
//  Project
//
//  Created by Monica Girgis Kamel on 05/12/2021.
//

import Foundation

struct httpHeader:Decodable {
    var key:String
    var value:String
}

public enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

protocol Endpoint{
    var base: String { get }
    var urlSubFolder: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = urlSubFolder + path
        if !queryItems.isEmpty{
            components.queryItems = queryItems
        }
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var request =  URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
}
