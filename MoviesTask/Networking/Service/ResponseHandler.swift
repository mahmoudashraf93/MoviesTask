//
//  ResponseHandler.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}
class ResponseHandler {
    
    static func validateResponse(_ response: URLResponse?, data: Data?, error: Error? = nil) -> String? {
        
        if let error = error {
            
            return error.localizedDescription
        }
        guard let responseData = data else {
            return NetworkResponse.noData.rawValue
            
        }

        if let response = response as? HTTPURLResponse {
            print(response.statusCode)
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                return nil
                
            case .failure(let networkFailureError):
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    if let jsonResponse = jsonData as? [String: Any], let message = jsonResponse["status_message"] as? String {
                        
                        return message
                    }
                    return networkFailureError
                }
                catch {
                    return networkFailureError
                }
            }
        }
        return NetworkResponse.failed.rawValue
        
    }
    static func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200: return .success
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
