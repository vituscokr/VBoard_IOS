//
//  MovieView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/28.
//
//https://engineering.nodesagency.com/categories/ios/2020/03/16/Combine-networking-with-a-hint-of-swiftUI 참고 
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-enable-pull-to-refresh
//읽을거리 : https://blckbirds.com/post/mastering-pull-to-refresh-in-swiftui/
//https://developer.apple.com/documentation/swiftui/scrollview/refreshable(action:)/

import SwiftUI
import LSSLibrary


//InsetListStyle()
//SidebarListStyle()
//ListStyle
struct MovieView: View {
    @StateObject var model : MovieModel = MovieModel()
    var body: some View {
        List {
            ForEach(model.items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text(item.title)
                            .font(.headline)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable {
            Debug.log("refresh")
        }
        .border(Color.red, width: 1)
        
        //        ScrollView {
        //
        //            LazyVStack {
        //
        //                ForEach(model.items) { item in
        //                    HStack {
        //                        Text(item.title)
        //                            .font(.headline)
        //                    }
        //                    .onAppear {
        //
        //                    }
        //                }
        //
        //            }
        //
        //        }
        //        .refreshable {
        //            Debug.log("refresh")
        //        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
