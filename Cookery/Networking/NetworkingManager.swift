//
//  NetworkingManager.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 18.05.21.
//

import Foundation

class NetworkingManager: NSObject, URLSessionDelegate {
    enum CustomError: Error {
        case invalidBaseUrl
        case invalidHttpBody
        case invalidResponseData
    }
    
    enum HTTPMethod {
        case get
        case post(_ content: Encodable)
        case put(_ content: Encodable)
        case delete
    }
    
    static let shared = NetworkingManager()
    private override init() {}
    
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    func request<T: Decodable>(forUrl urlString: String,
                               httpMethod: HTTPMethod,
                               queryParameters: [String: String],
                               completion: @escaping ((Result<T, Error>)->())) {
        guard var urlComponent = URLComponents(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(CustomError.invalidBaseUrl))
            }
            return
        }
        urlComponent.queryItems = queryParameters.keys.map { URLQueryItem(name: $0, value: queryParameters[$0]) }
        
        guard let url = urlComponent.url else {
            DispatchQueue.main.async {
                completion(.failure(CustomError.invalidBaseUrl))
            }
            return
        }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        switch httpMethod {
        case .get:
            request.httpMethod = "GET"
        case .post(let content):
            request.httpMethod = "POST"
            if let data = content.toJSONData() {
                request.httpBody = data
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.invalidHttpBody))
                }
                return
            }
        case .put(let content):
            request.httpMethod = "PUT"
            if let data = content.toJSONData() {
                request.httpBody = data
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.invalidHttpBody))
                }
                return
            }
        case .delete:
            request.httpMethod = "DELETE"
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let data = data,
               let result = try? JSONDecoder().decode(T.self, from:  data) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.invalidResponseData))
                }
            }
            
        }
        task.resume()
    }
}

private extension Encodable {
    func toJSONData() -> Data? { try? JSONEncoder().encode(self) }
}
