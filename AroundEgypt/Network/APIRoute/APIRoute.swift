//
//  APIRoute.swift
//  Project
//
//  Created by Monica Girgis Kamel on 05/12/2021.
//

import Foundation

class APIRoute{
    
    static let shared:APIRoute = APIRoute()
    private var timer:Timer?
    private var sessionTask:URLSessionDataTask?
    private init(){}
    
    private func initRequest(_ clientRequest:AroundEgypt)->URLRequest? {
        var request:URLRequest = clientRequest.request
        
        
        request.httpMethod = clientRequest.method.rawValue
        if clientRequest.body != nil{
            let jsonData = try? JSONSerialization.data(withJSONObject: clientRequest.body as Any, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        request.addHeaders(clientRequest.headers)
        
        print("=======================================")
        print(request)
        print(clientRequest.body ?? [:])
        print(clientRequest.queryItems)
        print(request.allHTTPHeaderFields ?? [:])
        print("=======================================")
        return request
    }
    
    private func JSONTask<T:Decodable>(with request: URLRequest, decodingModel: T.Type,clientRequest: AroundEgypt, completion: @escaping (Result<T, APIError>)-> Void) -> URLSessionDataTask {
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...204:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                var responseModel:T!
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    guard JSONSerialization.isValidJSONObject(json) else {
                        completion(.failure(.invalidData))
                        return
                    }
                    responseModel = try JSONDecoder().decode(T.self, from: data)
                } catch let err {
                    print("request url:\(String(describing: request.url)) with serialization error \(err)")
                    
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                completion(.success(responseModel))
                
                
                
            case 400...504:
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                var responseModel:Response<EmptyResponse>!
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    guard JSONSerialization.isValidJSONObject(json) else {
                        completion(.failure(.invalidData))
                        return
                    }
                    responseModel = try JSONDecoder().decode(Response<EmptyResponse>.self, from: data)
                } catch let err {
                    print("request url:\(String(describing: request.url)) with serialization error \(err)")
                    
                    completion(.failure(.jsonConversionFailure))
                    return
                }
                completion(.failure(.FlagFound(error: responseModel.meta.errors?.map({ $0.message ?? ""}).joined(separator: ", ") ?? "Flag Found with no error message")))
                
            default:
                completion(.failure(.responseUnsuccessful))
            }
        }
        return task
    }
    
    func fetchRequest<T: Decodable>(has loading: Bool = true, clientRequest: AroundEgypt, decodingModel: T.Type, completion: @escaping (Result<T, APIError>) -> ()){
        
        guard let urlRequest:URLRequest = self.initRequest(clientRequest) else {return}
        
        let dataTask = self.JSONTask(with: urlRequest, decodingModel: decodingModel.self, clientRequest: clientRequest) { [weak self] (result) in
            self?.timer?.invalidate()
            self?.timer = nil
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        dataTask.resume()
    }
    
    private func handleResponse<T: Decodable>(_ task:URLSessionTask, _ response: Result<T,APIError>)->Result<T,APIError>? {
        return response
    }
}

