//
//  MovieAPI.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/28.
//

import Foundation
import SwiftyJSON
import LSSLibrary
import Alamofire
import Combine

enum MovieAPI : URLConvertible {

    static let apiKey = "d665e09462517ea65bc5527214f208c0"
    case trendingMovieWeekly
    
    
    var path: String {
        
        switch(self) {
            case .trendingMovieWeekly: return "/trending/movie/week"
        }
    }
    
    var httpMethod : HTTPMethod {
        switch(self) {
            case .trendingMovieWeekly: return .get
        }
    }
    
    var baseURL : String {
        return "https://api.themoviedb.org/3"
    }
    
    
    var encoding : ParameterEncoding {
        switch(self) {
        //return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    func asURL() throws -> URL {
        let url = baseURL + path
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var urlComponent = URLComponents(string: encodedURL)!
        
        //api key 추가
        urlComponent.queryItems = [URLQueryItem(name: "api_key", value: MovieAPI.apiKey)]
        
        return urlComponent.url!
        
    }
    
    
    func fetch<T:Decodable>(parameters: Parameters? = nil ) -> AnyPublisher<T, RequestError> {
        
        return APIManager.shared.session.request(self, method: self.httpMethod, parameters: parameters, encoding: self.encoding)
            .validate()
            .publishDecodable(type:T.self)
            .value()
            .mapError {
                RequestError.requestFailError(error: $0 as Error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
