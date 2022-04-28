//
//  APIManager.swift
//  Susuda
//
//  Created by Gyeongtae Nam on 2022/01/10.
//

import Foundation

import Alamofire
import SwiftUI

class APIManager {
    static let shared = APIManager()
    
    let session:Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30  //타임아웃 시간 30초로 설정
        configuration.waitsForConnectivity = true //인터넷 연결 기다렸다가 요청
        
        let apiLogger = APIEventLogger()
        return Session(configuration: configuration,
                       interceptor: AuthInterceptor(),
                       eventMonitors: [apiLogger])
        }()
   
}

