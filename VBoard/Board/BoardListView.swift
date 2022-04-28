//
//  BoardListView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//

import SwiftUI

struct BoardListView: View {
    
    @StateObject var model = BoardModel()
    
    var body: some View {
        List(model.items) { item in
            
            Text(item.subject)
                .onAppear {
                    //model.loadMoreContentIfNeeded(currentItem: item)
                }
        }
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView()
    }
}
