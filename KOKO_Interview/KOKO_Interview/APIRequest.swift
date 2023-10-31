//
//  APIRequest.swift
//  KOKO_Interview
//
//  Created by TPI on 2023/10/25.
//

import Foundation
import UIKit

enum NetworkError: Swift.Error {
    case notHTTPResponse
    case noData
    case decodeError
    case networkError
}

protocol APIService {
    func fetchObject<Response: Codable>(endPoint: String, resModel: Response.Type, completion: @escaping (Response) -> Void, onError: @escaping (NetworkError) -> Void)
}

class NetworkProvider: NSObject, URLSessionDelegate {
    private lazy var urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    func fetchData(requestURL: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: requestURL) else {
            print("URL parse failure.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        urlSession.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.notHTTPResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                guard let responseData = data else {
                    completion(.failure(.noData))
                    return
                }
                
                completion(.success(responseData))
            default: completion(.failure(.networkError))
            }
        }.resume()
    }
}

class APIRequest: APIService {
    private let networkProvider = NetworkProvider()
    private let url = "https://dimanyen.github.io/"
    
    func fetchObject<Response: Codable>(endPoint: String, resModel: Response.Type, completion: @escaping (Response) -> Void, onError: @escaping (NetworkError) -> Void) {
        networkProvider.fetchData(requestURL: url + endPoint) { result in
            switch result {
            case .success(let originalData):
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: originalData)
                    if let dict = jsonDict as? [String: Any],
                       let response = dict["response"] {
                        let mainData = try JSONSerialization.data(withJSONObject: response)
                        let data = try JSONDecoder().decode(Response.self, from: mainData)
                        completion(data)
                    }
                } catch {
                    print("decode error: \(error)")
                    onError(.decodeError)
                }
            case .failure(let error):
                onError(error)
            }
        }
    }
}

class MockAPIRequest: APIService {
    func fetchObject<Response: Codable>(endPoint: String, resModel: Response.Type, completion: @escaping (Response) -> Void, onError: @escaping (NetworkError) -> Void) {
        guard let file = endPoint.components(separatedBy: ".").first else {
            print("endPoint error: \(endPoint)")
            return
        }
        
        if let path = Bundle.main.path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonDict = try JSONSerialization.jsonObject(with: data)
                
                if let dict = jsonDict as? [String: Any],
                   let response = dict["response"] {
                    let mainData = try JSONSerialization.data(withJSONObject: response)
                    let data = try JSONDecoder().decode(Response.self, from: mainData)
                    completion(data)
                } else {
                    print("dict error: \(endPoint)")
                }
            } catch {
                print("file error: \(endPoint), error: \(error)")
            }
        } else {
            print("path error: \(endPoint)")
        }
    }
}
