//
//  APIEventLogger.swift
//  Susuda
//
//  Created by Gyeongtae Nam on 2022/01/10.
//

import Foundation
import Alamofire
import LSSLibrary

class APIEventLogger : EventMonitor {

    let queue =  DispatchQueue(label:  (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "kr.co.vitus")  +  ".networkLogger")
    
    func requestDidFinish(_ request: Alamofire.Request) {
        guard AppConstant.environment != .production else {
            return
        }
        Debug.log("🛰 NETWORK Reqeust LOG")
        Debug.log(request.description)
        Debug.log("URL:" + (request.request?.url?.absoluteString ?? ""))
        Debug.log("Method:" + (request.request?.httpMethod ?? ""))
        
        let data = request.request?.httpBody ?? Data()
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        let parameters = string.removingPercentEncoding
        
        //Debug.log("Parameters: " +  parameters)
        Debug.log("Parameters: " + parameters!  )
        Debug.log("headers:" + "\(request.request?.allHTTPHeaderFields ?? [:])")
        Debug.log("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        Debug.log("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
        
    }
    
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard AppConstant.environment != .production else {
            return
        }
        
        Debug.log("🛰 NETWORK Response LOG")
        Debug.log("URL: " + (request.request?.url?.absoluteString ?? ""))
        Debug.log("Result: " + "\(response.result)")
        Debug.log("StatusCode: " + "\(response.response?.statusCode ?? 0)" )
        Debug.log("Data: \(response.data?.toPrettyPrintedString ?? "")")
        
    }
    

}
extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
