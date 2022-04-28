//
//  WebPages.swift
//  SusudaB2B
//
//  Created by Gyeongtae Nam on 2022/03/16.
//

import Foundation
import Alamofire
enum WebPages : URLConvertible {
    case articlePage // 이용약관
    case privacyPage  // 개인정보
    case thirdPage // 제 3자
    
    
    var baseURL : String {
        return ""
    }
    
    var path : String {
        switch(self) {
        case .articlePage:
            return "https://susuda-b2b-comm-storage.s3.ap-northeast-2.amazonaws.com/terms/term_of_service.html"
        case .privacyPage:
            return "https://susuda-b2b-comm-storage.s3.ap-northeast-2.amazonaws.com/terms/privacy_policy.html"
        case .thirdPage:
            return "https://susuda-b2b-comm-storage.s3.ap-northeast-2.amazonaws.com/terms/provision_personal_info.html"
        }
    }
    
    var title: String {
        
        switch(self) {
        case .articlePage:
            return "서비스 이용약관"
        case .privacyPage:
            return "개인정보 처리방침"
        case .thirdPage:
            return "개인정보 제3자 제공"
        }
    }
    
    func asURL() throws -> URL {
        
        let urlString = baseURL + path
        let url = URL(string: urlString)
        return url!
    }
    
    var request: URLRequest? {
        let urlString = baseURL + path
        guard let url = URL(string: urlString) else { return  nil }
        let urlRequest = URLRequest(url:url)
//        let accessToken = Config.shared.read(key: .accessToken, initStr: "")
//        urlRequest.addValue(accessToken, forHTTPHeaderField: "Authorization") 
        return urlRequest
    }
    
    
}
