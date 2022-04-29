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


struct ResponseOK: Codable {
    var success: Bool
}
struct APIResponseList  :Codable{
    var metadata:Metadata
    var items : [Board]
}

struct Board:Identifiable,  Codable , Equatable{

    var id : Int
    var subject : String
    var content: String 
//    enum CodingKey
    
    
}

class BoardModel : ObservableObject {
    
    @Published var items :[Board] = [Board]()
    @Published var isLoading: Bool = false
    
    var page : Int = 1
    var per : Int = 10
    var isAnyMore: Bool = true
    
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
    
    func loadMoreIfNeeded(currnetItem: Board) {
        
        if items.last == currnetItem {
            
            if isAnyMore {
                loadMore()
            }
        }
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
                
                
                if response.items.count < self.per {
                    self.isAnyMore = false
                }else {
                    self.isAnyMore = true
                }
                
                self.items += response.items
            })
            .store(in: &disposeBag)
        
    }
    
}


extension BoardModel {
    
    func delete (item: Board)  {
        
        
        let id = item.id
        let publisher : AnyPublisher<ResponseOK, RequestError> = Router.deleteBoard(String(id)).fetch()
        
        publisher
            .sink { completion in
                switch(completion) {
                case .failure(let error):
                    Debug.log(error)
                case .finished:
                    Debug.log("success")
                }
                self.loadData()
                
            } receiveValue: { response in
                
                
                Debug.log(response)
            }
            .store(in: &disposeBag)

        
        
    }
    
    func add(board: Board) {
        
        let arg = [
            "subject" : board.subject ,
            "content": board.content
        ]
        
        let publisher : AnyPublisher<Board, RequestError> = Router.postBoard.fetch(parameters: arg)
        
        publisher
            .sink { completion in
                switch(completion) {
                case .failure(let error):
                    Debug.log(error)
                case .finished:
                    Debug.log("success")
                }
                self.loadData()
                
            } receiveValue: { response in
                
                
                Debug.log(response)
            }
            .store(in: &disposeBag)
        
    }
    
    func update(board:Board) {
        
        
        let arg = [
            "subject" : board.subject ,
            "content": board.content
        ]
        
        
        let publisher : AnyPublisher<Board, RequestError> = Router.patchBoard("\(board.id)").fetch(parameters: arg)
        
        publisher
            .sink { completion in
                switch(completion) {
                case .failure(let error):
                    Debug.log(error)
                case .finished:
                    Debug.log("success")
                }
                self.loadData()
                
            } receiveValue: { response in
                
                
                Debug.log(response)
            }
            .store(in: &disposeBag)
        
    }
}
