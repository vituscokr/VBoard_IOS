//
//  AuthInterceptor.swift
//  Susuda
//
//  Created by Gyeongtae Nam on 2022/01/10.
//

import Foundation
import Alamofire
import SwiftyJSON
import LSSLibrary


class AuthInterceptor : RequestInterceptor {
    
    let retryLimit = 1 // 한번일 경우 0
    let retryDelay: TimeInterval = 5
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var urlRequest = urlRequest

        guard let path = urlRequest.url?.path else {
            return
        }

        var token = ""
        switch(path) {
        case "/token":
            token = ConfigStorage.shared.read(key: .refreshToken)
        default:
            token = ConfigStorage.shared.read(key: .accessToken)
        }
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        urlRequest.setValue("\(deviceId)", forHTTPHeaderField: "device-id")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Alamofire.Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let statusCode = request.response?.statusCode
        
        Debug.log(statusCode)
        
        
        guard  statusCode == 401  else{
            return completion(.doNotRetry)
        }
        
        Router.patchToken.request{ data, error in
            
            
            guard error == nil else {
                completion(.doNotRetry)
                return
            }
            
            guard let data = data else {
                completion(.doNotRetry)
                return
            }
            
            let accessToken = data["accessToken"].string ?? ""
            let refreshToken = data["refreshToken"].string ?? ""
            let userId = data["userId"].string ?? ""
            
            ConfigStorage.shared.save(key: .accessToken, value: accessToken)
            ConfigStorage.shared.save(key: .refreshToken, value: refreshToken)
            ConfigStorage.shared.save(key: .userId, value: userId)
            
            let token = ConfigStorage.shared.read(key: .refreshToken)
            
            if token.isEmpty {
                if request.retryCount < self.retryLimit {
                    completion(.retryWithDelay(self.retryDelay))
                }
            }else {
                completion(.retryWithDelay(self.retryDelay))
            }
            
//            if request.retryCount < self.retryLimit {
//                completion(.retryWithDelay(self.retryDelay))
//            }
        }
    }
}
