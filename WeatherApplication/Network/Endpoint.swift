//
//  Endpoint.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import Foundation

final class Endpoint {
    
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getBaseRequest<T: Decodable>(url: URL,
                                    completionHandler completion:  @escaping (_ object: T?,_ error: Error?) -> ()) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, ResponseError.requestFailed)
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        do {
                            let data = try self.decoder.decode(T.self, from: data)
                            completion(data, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ResponseError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
}
