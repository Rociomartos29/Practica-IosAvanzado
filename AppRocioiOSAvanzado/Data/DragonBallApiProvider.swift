//
//  ApiProvider.swift
//  AppRocioiOSAvanzado
//
//  Created by Rocio Martos on 24/2/24.
//

import Foundation
import SwiftData

struct HTTPMethods {
    static let post = "POST"
    static let get = "GET"
    static let put = "PUT"
    static let delete = "DELETE"
    static let contentType = "application/json"
    static let auth = "Authorization"
}

struct HTTPResponseCodes {
    static let SUCCESS = 200
    static let NOT_AUTHORIZED = 401
    static let NOT_FOUND = 404
    static let BAD_SERVER = 500
}

enum EndPoints: String{
    case url = "https://dragonball.keepcoding.education/api"
    case login = "/auth/login"
    case heroes = "/heros/all"
    case transform = "/heros/tranformations"
    case localization = "/heros/locations"
}
enum DragonBallError: Error {
    case server(error: Error)
    case statusCode(code: Int, message: String?)
    case noData
    case parsingData(error: Error)
}

struct DragonBallApiProvider {
    
    private let session: URLSession
    private var secureData: SecureDataProtocol
 
   
    init(session: URLSession = URLSession.shared,
         secureData: SecureDataProtocol = SecureDataKeychain()) {
        self.session = session
        
        self.secureData = secureData
       
    }
    
    func login(user: String, pass: String, completion: @escaping (Result<String, DragonBallError>) -> Void) {
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.login.rawValue)") else {
            completion(.failure(.server(error: NSError(domain: "", code: 0, userInfo: nil))))
            return
        }
        
        let loginString = String(format: "%@:%@", user, pass)
        guard let loginData = loginString.data(using: .utf8)?.base64EncodedString() else {
            completion(.failure(.parsingData(error: NSError(domain: "", code: 0, userInfo: nil))))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.server(error: error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCode(code: (response as? HTTPURLResponse)?.statusCode ?? 0, message: "")))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.parsingData(error: NSError(domain: "", code: 0, userInfo: nil))))
                return
            }
            
            self.secureData.setToken(value: token)
            completion(.success(token))
        }.resume()
    }
    
    func getSuperheroes(completion: @escaping (Result<[Heroes], DragonBallError>) -> Void) {
        getData(endpoint: EndPoints.heroes.rawValue, dataRequest: "name", value: "", completion: completion)
    }
    
    func getTransformation(idHeroe: String, completion: @escaping (Result<[Transformaciones], DragonBallError>) -> Void) {
        getData(endpoint: EndPoints.transform.rawValue, dataRequest: "id", value: idHeroe) { (result: Result<[Transformaciones], DragonBallError>) in
                    switch result {
                    case .success(let transformations):
                        completion(.success(transformations))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    
    
    func getLocation(idHeroe: String, completion: @escaping (Result<[Location], DragonBallError>) -> Void) {
        getData(endpoint: EndPoints.localization.rawValue, dataRequest: "id", value: idHeroe) { (result: Result<[Location], DragonBallError>) in
                    switch result {
                    case .success(let locations):
                        completion(.success(locations))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    
    
    private func getData<T: Decodable>(endpoint: String, dataRequest: String, value: String, completion: @escaping (Result<T, DragonBallError>) -> Void) {
        guard let url = URL(string: "\(EndPoints.url.rawValue)\(endpoint)") else {
                    completion(.failure(.server(error: NSError(domain: "", code: 0, userInfo: nil))))
                    return
                }
                
                guard let token = secureData.getToken() else {
                    completion(.failure(.noData))
                    return
                }
                
                var components = URLComponents()
                components.queryItems = [URLQueryItem(name: dataRequest, value: value)]
                
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethods.post
                request.setValue("Bearer \(token)", forHTTPHeaderField: HTTPMethods.auth)
                request.httpBody = components.query?.data(using: .utf8)
                
                session.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        completion(.failure(.server(error: error!)))
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(.server(error: NSError(domain: "", code: 0, userInfo: nil))))
                        return
                    }
                    
                    if !(200...299).contains(httpResponse.statusCode) {
                        var errorMessage: String?
                        switch httpResponse.statusCode {
                        case 401:
                            errorMessage = "No autorizado: se requiere autenticación"
                        case 404:
                            errorMessage = "No encontrado: los datos solicitados no fueron encontrados"
                        default:
                            errorMessage = "Error del servidor con código \(httpResponse.statusCode)"
                        }
                        completion(.failure(.statusCode(code: httpResponse.statusCode, message: errorMessage)))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                        print(decodedData)
                    } catch {
                        completion(.failure(.parsingData(error: error)))
                    }
                }.resume()
            }
        }


