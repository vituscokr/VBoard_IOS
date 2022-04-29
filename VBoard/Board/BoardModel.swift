//
//  BoardModel.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//

import Foundation
import LSSLibrary
import Combine
import Alamofire
import SwiftyJSON

struct Metadata :Codable {
    var per:Int
    var page: Int
    var total :Int
    
}

struct APIResponseList  :Codable{
    var metadata:Metadata
    var items : [Board]
}

struct Board:Identifiable,  Codable {

    var id : Int
    var subject : String
    
//    enum CodingKey
    
    
}

class BoardModel : ObservableObject {
    
    @Published var items :[Board] = [Board]()
    @Published var isLoading: Bool = false
    
    var page : Int = 1
    var per : Int = 10
    
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        loadData()
    }
    
    func loadData() {
        Debug.log("loadData")
        
        
        items.removeAll()
        page = 1
        fetch()
    }
    
    func loadMore() {
        page = page + 1
        fetch()
    }
    
    func fetch() {
        guard !isLoading else {
            return
        }
        isLoading = true
        
        let arg = [
            "page":page,
            "per": 10
        ]
        
        let publisher : AnyPublisher <APIResponseList , RequestError> = Router.getBoardList.fetch(parameters: arg)
        
        publisher

//            .handleEvents(receiveOutput: { response in
//                Debug.log(response)
//            })
            .sink(receiveCompletion: { completion in
                switch(completion) {
                case .failure(let error):
                    Debug.log(error)
                case .finished:
                    Debug.log("success")
                }
                self.isLoading = false
                Debug.log("done")
            }, receiveValue: { response in
                
                Debug.log(response)
                Debug.log(response.metadata)
                Debug.log(response.items)
                
                self.items += response.items
            })
            .store(in: &disposeBag)
        
    }
    
}
