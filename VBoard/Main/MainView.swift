//
//  MainView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//

import SwiftUI

struct MainView: View {
    
    var userId:String {
        return ConfigStorage.shared.read(key: .userId)
    }
    var body: some View {
        VStack {
            
            BoardListView()
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
