//
//  Route.swift
//  Susuda
//
//  Created by Gyeongtae Nam on 2022/01/07.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import LSSLibrary
import Combine


enum Router : URLConvertible {
    
    case postLogin
    case patchToken
    case getBoardList
    case deleteBoard(String)
    case postBoard
    
    
    var path : String {
        switch(self) {
        case .postLogin: return "/login"
        case .patchToken: return "/token"
        case .getBoardList: return "/board"
        case .deleteBoard(let id) : return "/board/\(id)"
        case .postBoard: return "/board"
        }
    }
    
    var httpMethod : HTTPMethod {
        switch(self) {
        case .postLogin: return .post
        case .patchToken: return .patch
        case .getBoardList: return .get
        case .deleteBoard(_) : return .delete
        case .postBoard: return .post
        }
    }
    
//    var headers : HTTPHeaders? {
//        return HTTPHeaders()
//    }
    var baseURL: String {
        return AppConstant.severURL
    }
    
    var encoding : ParameterEncoding {
        switch(self) {
        case .postLogin,
            .postBoard:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    func asURL() throws -> URL {
        let url = baseURL + path
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlComponent = URLComponents(string: encodedURL)!
        
        return urlComponent.url!
        
    }
    
    
//    import Foundation
//    import Combine
//
//    struct APIClient {
//
//        struct Response<T> { // 1
//            let value: T
//            let response: URLResponse
//        }
//        
//        func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> { // 2
//            return URLSession.shared
//                .dataTaskPublisher(for: request) // 3
//                .tryMap { result -> Response<T> in
//                    let value = try JSONDecoder().decode(T.self, from: result.data) // 4
//                    return Response(value: value, response: result.response) // 5
//                }
//                .receive(on: DispatchQueue.main) // 6
//                .eraseToAnyPublisher() // 7
//        }
//    }
    
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
    
    func request(parameters: Parameters? = nil , onCompletedHandler:@escaping(_ data:JSON?, RequestError?) ->()) {
        
        APIManager.shared.session.request(self, method: self.httpMethod, parameters: parameters, encoding: self.encoding)
        // .validate(statusCode: 200..<300)
            .responseDecodable(of:JSON.self ) { response in
                switch(response.result) {
                case .success(let value):
                    
//                    if let error = value["error"].string  , !error.isEmpty {
//                        let message = value["message"].string ?? ""
//                        let errorDetails = value["errorDetails"]
//                        Debug.log(errorDetails)
//                        onCompletedHandler(nil, RequestError.requestError(message: message))
//                        return
//                    }
//
//                    let success  = value["success"].bool
//                    if success == false {
//
//                        if let message = value["message"].string , !message.isEmpty {
//                            onCompletedHandler(nil, RequestError.requestError(message: message))
//                        }else {
//                            onCompletedHandler(nil, RequestError.requestNoSuccess)
//                        }
//                        return
//                    }
//
//                    let data = value["data"]
                    onCompletedHandler(value, nil)
                case .failure(let error ):
                    
                    onCompletedHandler(nil, RequestError.requestFailError(error: error))
                    
                }
                
            }
        
    }
}
    
    /*
     아래는 수수다 내용입니다.
     enum  Router :URLConvertible {
     
     ///{U1} 로그인(고객)
     case postLogin  //"id", "password" , "areaId" //@@
     
     case refreshToken
     ///{C7} 이미지 업로드
     case postFiles //fileFolderId *  //files //
     ///{C8} 이미지 조회
     case getFiles(String)
     ///{C20} 이미지 폴더 조회
     case getFilesInFolder(String)
     
     
     
     ///{C3} 알림목록 조회
     case getNotificationList  ///push?cursor&take=10&orderBy&new
     ///{C4} 알림 삭제 요청"
     case deleteNotification // "idList": [1,2,3,4,5]
     ///{C5} 알림 읽음 요청
     case patchNotification
     ///{C6} 알림 설정
     case patchNotificationAlarm
     ///{C2} 읽지않은 알림 건수
     case getNotificationNew
     
     ///건물
     ///{U2} 건물 목록 조회2
     case getUserBuildings
     ///{C9} 건물 조회
     case getBuildings(String)
     ///{C10} 건물의 호수목록 조회
     case getBuildingHouses(String) //zeus/buildings/:id/houses
     
     //{U8} 총 결제금액 조회
     case getPayment
     ///이것은 무엇일까요? {U9} 주문서 등록 및 결제요청
     /////{U8} 총 결제금액 조회
     case postPayment
     
     ///{U9}  주문서 등록 및 결제요청
     case postPay
     ///{U9-1} 결제배너를 통한 결제요청
     case postPayByJobId(String)
     
     ///{U10} 결제 완료 처리 요청
     case postPaymentComplete
     
     //    ///{A2} 신규 주문 현황
     //    case getJobStats
     //    ///{A18} 주문 목록(신청현황) 조회
     //    case getJobs
     //{U3} 주문 목록(신청현황) 조회2
     case getJobUser
     ///{C11} 주문 조회(신청현황상세)
     case getJob(String)
     ///{C12} 주문 취소
     case patchJobCancel(String)
     /// {U6} 주문서 현황 조회
     case getJobUserStat
     ///{U7} 주문서 조회
     case getJobRequested(String)
     
     
     ///{C13} 대분류/중분류 목록 조회
     case getServiceBranches
     ///{C13} 대분류/중분류 목록 조회
     case getServiceBranchesChild([Int])
     
     ///{C14} 소분류 목록 조회
     case getServices
     
     case getServicesByMiddleCate(Int, [Int])
     ///{C15} 자재 목록 조회
     case getMaterial([Int])
     
     ///{U4} 지역 변경
     case patchArea(String)
     ///{U5} 고객 정보 조회
     case getProfile
     ///{C17} FCM토큰 갱신
     case patchFCMToken
     ///{C18} 파일 폴더 삭제
     case deleteFileFolder(String,String)
     ///{C21} 로그아웃
     case postLogout
     ///{U11} 시공 확정보고서 확인
     case patchConfirmReport(String)
     ///{U12} 시공 예정일 변경 확인
     case patchConfirmDate(String)
     
     var baseURL : String {
     return AppConstant.severURL
     }
     
     var path : String {
     switch(self) {
     case .postLogin: return "/zeus/login"
     case .refreshToken : return "/zeus/refresh"
     case .postFiles: return "/files"
     case .getFiles(let id) : return "/files/\(id)"
     case .getFilesInFolder(let id ) : return "/files/folders/\(id)"
     case .getNotificationList: return "/push"
     case .deleteNotification : return "/push"
     case .patchNotification : return "/push/read"
     case .patchNotificationAlarm: return "/push/user"
     case .getNotificationNew: return "/push/new"
     
     case .getUserBuildings: return "/zeus/buildings/user"
     case .getBuildings(let id) : return "/zeus/buildings/\(id)"
     case .getBuildingHouses(let id) : return "/zeus/buildings/\(id)/houses"
     
     case .getPayment: return "/zeus/jobs/payment"
     case .postPayment: return "/zeus/jobs/bill"
     case .postPaymentComplete: return "/payments/complete"
     
     case .getJobUser: return "/zeus/jobs/user"
     case .getJob(let id) : return "/zeus/jobs/\(id)"
     case .patchJobCancel(let id) : return "/zeus/jobs/\(id)/cancel"
     case .getJobUserStat : return "/zeus/jobs/user/stats"
     case .getJobRequested(let id) : return "/zeus/jobs/\(id)/requested"
     
     case .getServiceBranches: return "/zeus/service-branches"
     case .getServiceBranchesChild(let args):
     
     var param : String = ""
     for (i,arg)  in args.enumerated() {
     if i == 0 {
     param = param + "?"
     }
     param = param + "parentBranchId=\(arg)"
     if i < args.count - 1 {
     param = param + "&"
     }
     }
     return "/zeus/service-branches" + param
     
     case .getServicesByMiddleCate(let houseId, let args):
     var param : String = "?"
     param = param + "houseId=\(houseId)&"
     for (i,arg)  in args.enumerated() {
     
     param = param + "parentBranchId=\(arg)"
     if i < args.count - 1 {
     param = param + "&"
     }
     }
     return "//zeus/services" + param
     case .getServices:  return "/zeus/services"
     case .getMaterial(let args):
     var param : String = ""
     for (i,arg)  in args.enumerated() {
     if i == 0 {
     param = param + "?"
     }
     param = param + "serviceId=\(arg)"
     if i < args.count - 1 {
     param = param + "&"
     }
     }
     return "/zeus/services/materials" + param
     
     case .patchArea(let id): return "/zeus/users/area/\(id)"
     
     case .getProfile:  return "/zeus/users/profile"
     //
     case .patchFCMToken: return "/push/token"
     case .deleteFileFolder(let folderId, let taskId) : return "/files/folders/\(folderId)?\(taskId)"
     
     case .postPay: return "/zeus/jobs/payment"
     case .postPayByJobId(let jobId) : return "/zeus/jobs/payment/\(jobId)"
     case .postLogout : return "/zeus/logout"
     case .patchConfirmDate(let id) : return "/zeus/jobs/\(id)/confirmation-report/confirm/date-changed"
     case .patchConfirmReport(let id): return "/zeus/jobs/\(id)/confirmation-report/confirm"
     }
     
     }
     var httpMethod : HTTPMethod {
     switch(self) {
     case .postLogin: return .post
     case .refreshToken : return .patch
     case .postFiles: return .post
     case .getFiles(_) : return .get
     case .getFilesInFolder(_) : return .get
     case .getNotificationList : return .get
     case .deleteNotification : return .delete
     case .patchNotification: return .patch
     case .patchNotificationAlarm: return .patch
     case .getNotificationNew: return .get
     
     case .getUserBuildings : return .get
     case .getBuildings(_) : return .get
     case .getBuildingHouses(_) : return .get
     case .getPayment: return .get
     case .postPayment: return .post
     case .postPaymentComplete: return .post
     case .getJobUser: return .get
     case .getJob(_): return .get
     case .patchJobCancel(_): return .patch
     case .getJobUserStat: return .get
     case .getJobRequested(_): return .get
     case .getServiceBranches : return .get
     case .getServiceBranchesChild(_) : return .get
     case .getServices: return .get
     case .getServicesByMiddleCate(_, _) : return .get
     case .getMaterial(_): return .get
     
     case .patchArea(_): return .patch
     case .getProfile : return .get
     case .patchFCMToken: return .patch
     case .deleteFileFolder(_, _) : return .delete
     case .postPay: return .post
     case .postPayByJobId(_) : return .post
     case .postLogout : return .post
     case .patchConfirmDate(_) : return .patch
     case .patchConfirmReport(_) : return .patch
     }
     
     }
     
     
     //AuthInterceptor 로 치환
     var headers : HTTPHeaders? {
     
     let accessToken = ConfigStorage.shared.read(key: .accessToken)
     let refreshToken = ConfigStorage.shared.read(key: .refreshToken)
     
     var header: HTTPHeaders? = nil
     
     
     let token : String
     switch(self) {
     case .postLogin :
     return header
     
     case .refreshToken:
     
     //token = "Bearer " + refreshToken
     token = refreshToken.replacingOccurrences(of: "Bearer ", with: "")
     
     default:
     //token = "Bearer " + accessToken
     token = accessToken.replacingOccurrences(of: "Bearer ", with: "")  // AuthInterceptor 로 치환
     
     }
     if   token != ""   {
     header = [
     .authorization(token )
     ]
     let deviceId = ConfigStorage.shared.read(key: .deviceId)
     
     if deviceId != "" {
     header?.add(name: "device-id", value: deviceId )
     }
     }
     
     guard let r = header else {
     return nil
     }
     return r
     }
     
     var encoding : ParameterEncoding {
     switch(self) {
     case
     .postPayByJobId(_),
     .postLogout,
     .postPay,
     .getPayment,
     .patchNotification,
     .deleteNotification,
     .patchNotificationAlarm:
     
     
     return JSONEncoding.default
     default:
     return URLEncoding.default
     }
     }
     
     
     
     func asURL() throws -> URL {
     
     //10분전에 무조건 토큰을 갱신 합니다.
     let url = baseURL  + path
     let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
     let urlComponent = URLComponents(string: encodedURL)!
     
     return urlComponent.url!
     }
     
     
     func request(taskId: UUID, images: [UIImage] , onCompletedHandler:@escaping(_ data:JSON?, RequestError?) ->()) {
     
     let urlString  = baseURL  + path
     
     //        let url = URL(string: urlString)
     //         var request = URLRequest(url: url!)
     //         request.httpMethod = "POST"
     
     
     
     APIManager.shared.session.upload(multipartFormData: { (form) in
     //form append start
     
     for (i, pic ) in images.enumerated() {
     guard let data = pic.pngData() else { continue}
     let filename = "pictures_\(i)_\(Date().currentTimeStamp).png"
     form.append(data, withName: "files", fileName: filename, mimeType: "image/png")
     }
     
     
     //            Debug.log(taskId.uuidString)
     //
     
     form.append((taskId.uuidString).data(using: .utf8)!, withName: "taskId")
     
     
     //            for(key,value) in arg {
     //                form.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
     //            }
     //form append end
     },
     to: urlString ,
     usingThreshold: UInt64.init(),
     method: .post)
     .uploadProgress { (progress) in
     //Debug.log(progress.fractionCompleted)
     
     }
     .responseDecodable(of:JSON.self ) { response in
     switch(response.result) {
     case .success(let value):
     
     if let error = value["error"].string  , !error.isEmpty {
     let message = value["message"].string ?? ""
     let _ = value["errorDetails"]
     //                                                     Debug.log(errorDetails)
     onCompletedHandler(nil, RequestError.requestError(message: message))
     return
     }
     
     let success  = value["success"].bool
     if success == false {
     
     if let message = value["message"].string , !message.isEmpty {
     onCompletedHandler(nil, RequestError.requestError(message: message))
     }else {
     onCompletedHandler(nil, RequestError.requestNoSuccess)
     }
     return
     }
     
     let data = value["data"]
     onCompletedHandler(data, nil)
     case .failure(let error ):
     onCompletedHandler(nil, RequestError.requestFailError(error: error))
     }
     
     }
     
     
     }
     
     func request(json: JSON ,onCompletedHandler:@escaping(_ data:JSON?, RequestError?) ->()) {
     
     
     let string = json.rawString()
     guard let data = string?.data(using: .utf8, allowLossyConversion: false) else {
     onCompletedHandler(nil, RequestError.requestError(message: "json 형식화를 하지 못하였습니다."))
     return
     }
     
     var jsonedData = [String:AnyObject]()
     do {
     jsonedData =    try (JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject])!
     
     }catch {
     onCompletedHandler(nil, RequestError.requestError(message: "json 형식화를 하지 못하였습니다."))
     
     return
     
     }
     
     
     
     
     
     let urlString  = baseURL  + path
     
     let url = URL(string: urlString)
     var request = URLRequest(url: url!)
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpMethod = "POST"
     request.httpBody = try! JSONSerialization.data(withJSONObject: jsonedData, options: [])
     
     
     APIManager.shared.session.request(request)
     .responseDecodable(of:JSON.self ) { response in
     
     switch(response.result) {
     case .success(let value):
     
     if let error = value["error"].string  , !error.isEmpty {
     let message = value["message"].string ?? ""
     let _ = value["errorDetails"]
     //                        Debug.log(errorDetails)
     onCompletedHandler(nil, RequestError.requestError(message: message))
     return
     }
     
     let success  = value["success"].bool
     if success == false {
     
     if let message = value["message"].string , !message.isEmpty {
     onCompletedHandler(nil, RequestError.requestError(message: message))
     }else {
     onCompletedHandler(nil, RequestError.requestNoSuccess)
     }
     return
     }
     
     let data = value["data"]
     onCompletedHandler(data, nil)
     case .failure(let error ):
     
     onCompletedHandler(nil, RequestError.requestFailError(error: error))
     
     }
     }
     }
     
     
     func request(jsonArray: [[String:Any]] ,onCompletedHandler:@escaping(_ data:JSON?, RequestError?) ->()) {
     let urlString  = baseURL  + path
     
     let url = URL(string: urlString)
     var request = URLRequest(url: url!)
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpMethod = "POST"
     request.httpBody = try! JSONSerialization.data(withJSONObject: jsonArray, options: [])
     
     
     APIManager.shared.session.request(request)
     .responseDecodable(of:JSON.self ) { response in
     
     switch(response.result) {
     case .success(let value):
     
     if let error = value["error"].string  , !error.isEmpty {
     let message = value["message"].string ?? ""
     let errorDetails = value["errorDetails"]
     Debug.log(errorDetails)
     onCompletedHandler(nil, RequestError.requestError(message: message))
     return
     }
     
     let success  = value["success"].bool
     if success == false {
     
     if let message = value["message"].string , !message.isEmpty {
     onCompletedHandler(nil, RequestError.requestError(message: message))
     }else {
     onCompletedHandler(nil, RequestError.requestNoSuccess)
     }
     return
     }
     
     let data = value["data"]
     onCompletedHandler(data, nil)
     case .failure(let error ):
     
     onCompletedHandler(nil, RequestError.requestFailError(error: error))
     
     }
     }
     }
     
     func request(parameters: Parameters? = nil , onCompletedHandler:@escaping(_ data:JSON?, RequestError?) ->()) {
     
     
     //
     //         eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDEiLCJhcmVhSWQiOjEsImlhdCI6MTY0OTAzNTcxMywiZXhwIjoxNjgwNTcxNzEzfQ.ql5cLS0P6nEY_nWCG9-r9obQznPXkP1oKuVFCJghxqk'
     //
     
     APIManager.shared.session.request(self, method: self.httpMethod, parameters: parameters, encoding: self.encoding, headers: self.headers)
     // .validate(statusCode: 200..<300)
     .responseDecodable(of:JSON.self ) { response in
     
     
     //                Debug.log("arg:\(String(describing: parameters))")
     //                Debug.log("request : \(String(describing: response.request))")
     //                Debug.log("response : \(String(describing: response.response))")
     //                Debug.log("result: \(response.result)")
     //                Debug.log("data : \(String(describing: response.data))")
     //                Debug.log("headers : \(String(describing: headers))")
     
     //                if response.response?.statusCode == 401 {
     //                    Debug.log("This is request statusCode ")
     //                    if User.shared.isLogin {
     //                        User.shared.logout()
     //                    }
     //                    return
     //                }
     
     switch(response.result) {
     case .success(let value):
     
     if let error = value["error"].string  , !error.isEmpty {
     let message = value["message"].string ?? ""
     let errorDetails = value["errorDetails"]
     Debug.log(errorDetails)
     onCompletedHandler(nil, RequestError.requestError(message: message))
     return
     }
     
     let success  = value["success"].bool
     if success == false {
     
     if let message = value["message"].string , !message.isEmpty {
     onCompletedHandler(nil, RequestError.requestError(message: message))
     }else {
     onCompletedHandler(nil, RequestError.requestNoSuccess)
     }
     return
     }
     
     let data = value["data"]
     onCompletedHandler(data, nil)
     case .failure(let error ):
     
     onCompletedHandler(nil, RequestError.requestFailError(error: error))
     
     }
     
     }
     
     }
     
     
     /*
      func refreshToken(parameters: Parameters? = nil ,onCompletedHandler:@escaping(_ data:JSON?, RequestError?) ->() ) {
      
      
      AF.request(self, method: self.httpMethod, parameters: parameters , encoding: self.encoding , headers: self.headers)
      .responseDecodable(of:JSON.self ) { response in
      
      //Debug.log("arg:\(String(describing: parameters))")
      //                Debug.log("request : \(String(describing: response.request))")
      //                Debug.log("response : \(String(describing: response.response))")
      //                Debug.log("result: \(response.result)")
      //                Debug.log("data : \(String(describing: response.data))")
      //                Debug.log("headers : \(String(describing: headers))")
      
      
      switch(response.result) {
      case .success(let data) :
      if let error = data["error"].string  , !error.isEmpty {
      let message = data["message"].string ?? ""
      let errorDetails = data["errorDetails"]
      Debug.log(errorDetails)
      
      onCompletedHandler(nil, RequestError.requestError(message: message))
      return
      }
      
      let success  = data["success"].bool
      if success == false {
      onCompletedHandler(nil, RequestError.requestNoSuccess)
      return
      }
      
      let refreshToken = data["data"]["refreshToken"].string ?? ""
      let accessToken = data["data"]["accessToken"].string ?? ""
      //                    let expires = data["data"]["accessTokenExpiredAt"].int ?? 0
      //                    let expireRefresh = data["data"]["refreshTokenExpiredAt"].int ?? 0
      
      //                    Debug.log(refreshToken)
      //                    Debug.log(accessToken)
      //                    Debug.log(expires)
      //                    Debug.log(expireRefresh)
      
      guard refreshToken != "" , accessToken != "" else {
      onCompletedHandler(nil, RequestError.requestNoSuccess)
      return
      }
      
      
      
      Config.shared.save(key: .accessToken, value: accessToken)
      Config.shared.save(key: .refreshToken, value: refreshToken)
      // Config.shared.save(key: .username, value: username)
      //                    Config.shared.save(key: .tokenExpires, value: String(expires))
      //                    Config.shared.save(key: .tokenRefreshExpires, value: String(expireRefresh))
      
      onCompletedHandler(data , nil )
      
      case .failure(let error):
      onCompletedHandler(nil, RequestError.requestFailError(error: error))
      }
      }
      
      }
      */
     
     }
     */
