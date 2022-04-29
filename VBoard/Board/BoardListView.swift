//
//  BoardListView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//

import SwiftUI
import LSSLibrary

struct BoardListView: View {
    
    @StateObject var model = BoardModel()
    
    var body: some View {
        
        ZStack {
            List {
                
                
                ForEach(model.items) { item in
                    Text(item.subject)
                        .onAppear {
                            //model.loadMoreContentIfNeeded(currentItem: item)
                        }
                }
                .onDelete(perform: delete )
                
            }
            
            VStack{
                Spacer()
                NavigationLink {
                    BoardAddView()
                        .environmentObject(model)
                } label: {
                    Text("Add")
                        .padding() 
                }
            }
            
            
        }
        .onAppear(perform: load)
    }
    
    func delete(at indexSet :IndexSet ) {
        Debug.log("삭제")
        
        indexSet.map {
            
            model.delete(item: model.items[$0])
        }
        

        
        
        

        
//        let deleteItems :[Board] =  model.items.enumerated().filter { (i, item) -> Bool in
//
//           let remove = indexSet.contains(i)
//
//           if remove {
//               return true
//           }else {
//               return false
//           }
//
//        }
//
//
//
//        _ = deleteItems.map {
//            model.delete(item: $0)
//        }
        
    }
    
    
    func load() {
        
        let userid = ConfigStorage.shared.read(key: .userId)
        
        Debug.log(userid)
        
    }
}

struct BoardListView_Previews: PreviewProvider {
    static var previews: some View {
        BoardListView()
    }
}
