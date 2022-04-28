//
//  LaunchView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//

import SwiftUI

struct LaunchView: View {
    @StateObject var launchModel = LaunchModel.shared
    
    var body: some View {
        if launchModel.isLogin {
            MainView() 
        }else {
            LoginView()
                .environmentObject(launchModel)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
