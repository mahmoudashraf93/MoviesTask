//
//  Router.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private let session: URLSessionProtocol
    private var task: URLSessionDataTaskProtocol?
    init (session: URLSessionProtocol = URLSession.shared){
        self.session = session
    }
    @discardableResult
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) -> URLSessionDataTaskProtocol? {
        do {
            let request = try self.buildRequest(from: route)
            
           self.task = self.session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
        return self.task
    }
    
    func cancel() {
        self.task?.cancel()
    }
   
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .requestParameters(let urlParameters):
                
                try self.configureParameters(urlParameters: urlParameters,
                                             request: &request)
        
            case .download:
                // the url is already setup
               return request
            }
            return request

        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            if let urlParameters = urlParameters {
                try URLParameterEncoder().encode(urlRequest: &request,
                                                 with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    // in case we needed to add HTTPHeaders in the future
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
