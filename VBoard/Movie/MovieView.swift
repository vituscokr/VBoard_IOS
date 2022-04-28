//
//  MovieView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/28.
//
//https://engineering.nodesagency.com/categories/ios/2020/03/16/Combine-networking-with-a-hint-of-swiftUI 참고 

import SwiftUI

struct MovieView: View {
    @StateObject var model : MovieModel = MovieModel()
    var body: some View {
        List(model.items) { item in
                
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(item.title)
                            .font(.headline)
                        
//                        Text(item.title)
//                            .font(.headline)
//                        Text(item.orginalTitle)
//                            .font(.headline)
                    }
                }
            }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
