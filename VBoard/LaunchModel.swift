//
//  LaunchModel.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//

import Foundation
import LSSLibrary
import Combine
import SwiftyJSON


class LaunchModel: ObservableObject {
    private var disposeBag = Set<AnyCancellable>()
    @Published var isLogin:Bool = false
    
    static var shared = LaunchModel() 
    
    init() {
        let userId = ConfigStorage.shared.read(key: .userId)
        
        Debug.log(userId)
        
        
        if userId.isEmpty {
            isLogin = false
        }else {
            isLogin = true
        }
    }

}


extension LaunchModel  {
    
    
    func login(id:String, pass:String ) {
        
        let arg = [
            "userid": id,
            "passwd": pass
        ]
        
        let publisher : AnyPublisher<JSON, RequestError> = Router.postLogin.fetch(parameters: arg)
        
        publisher
            .receive(on: DispatchQueue.main)

            .sink(receiveCompletion: { completion  in
                switch(completion) {
                case .failure(let error):
                    Debug.log(error)
                case .finished:
                    Debug.log("success")
                }
            }, receiveValue: { value  in
                //
                let accessToken = value["accessToken"].string ?? ""
                let refreshToken = value["refreshToken"].string ?? ""
                let userId = value["userId"].string ?? ""
                
                ConfigStorage.shared.save(key: .accessToken, value: accessToken)
                ConfigStorage.shared.save(key: .refreshToken, value: refreshToken)
                ConfigStorage.shared.save(key: .userId, value: userId)
                
                self.isLogin = true
            })
            .store(in: &disposeBag)

    }
    
    func logout() {
        
        
        ConfigStorage.shared.delete(key: ConfigKey.accessToken.rawValue)
        ConfigStorage.shared.delete(key: ConfigKey.userId.rawValue)
        ConfigStorage.shared.delete(key: ConfigKey.refreshToken.rawValue)
        
        
        
    }
}
