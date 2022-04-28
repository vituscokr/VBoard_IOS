//
//  MovieModel.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/28.
//

import Foundation
import Combine
import LSSLibrary

struct MovieResponse : Codable {
    let movies : [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie : Identifiable, Codable {
    
    var id = UUID()
    let movieId :Int
    let originalTitle: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case originalTitle = "original_title"
        case title
    }
}

class MovieModel : ObservableObject {
    
    @Published var items : [Movie] = [Movie]()
    @Published var isLoading: Bool = false
    
    private var disposeBag = Set<AnyCancellable>()

    
    init() {
        loadData()
    }
    
}


extension MovieModel {
    
    func loadData() {
        
        guard !isLoading else {
            return
        }
        
        isLoading = true
    
        items.removeAll()
        
        
        
        let publisher :  AnyPublisher<MovieResponse, RequestError> = MovieAPI.trendingMovieWeekly.fetch()

        publisher
            .sink(receiveCompletion: { completion in
                switch(completion) {
                case .failure(let error):
                    Debug.log(error)
                case .finished:
                    Debug.log("success")
                }
                Debug.log("done")
                
                self.isLoading = false 
            }, receiveValue: { response in
                Debug.log(response)
                
                self.items += response.movies
                
            })
            .store(in: &disposeBag)

    }
    
    
}
