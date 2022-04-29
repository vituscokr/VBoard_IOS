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
        NavigationView{
            VStack {
                
                NavigationLink {
                    BoardListView()
                } label: {
                    
                    Text("Board")
                }
                
                NavigationLink {
                    MovieView()
                } label: {
                    
                    Text("Movie")
                }
                
                
                NavigationLink {
                    BarcodeView() 
                } label: {
                    Text("Barcode")
                }
                
                
                Button(action: logout) {
                    Text("로그아웃")
                }
                
                
            }
        }
    }
    
    func logout() {
        LaunchModel.shared.logout()
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
