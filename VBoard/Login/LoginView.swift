//
//  LoginView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//

import SwiftUI
import LSSLibrary
//참고 : https://blckbirds.com/post/login-page-in-swiftui-1/

let lightGrayColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
struct LoginView: View {
    @EnvironmentObject var launchModel : LaunchModel
    @State var id: String = ""
    @State var pass: String = ""
    @State var isDisableConfirm : Bool = true
    var body: some View {
      
        
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Image("main")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150, alignment: .center)
                .clipped()
                .cornerRadius(150)
                .padding(.bottom, 65)
    
            TextField("ID", text: $id)
                .padding()
                .background(lightGrayColor)
                .foregroundColor(Color.black)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("password", text:$pass)
                .padding()
                .background(lightGrayColor)
                .foregroundColor(Color.black)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: login ) {
                Text("LGOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                
                    .padding()
                    .frame(minWidth:0, maxWidth: .infinity, minHeight:60, maxHeight: 60, alignment: .center)
                    .background(isDisableConfirm ? Color.gray : Color.green)
                    .cornerRadius(15)
            }
            .disabled(isDisableConfirm)
            
        }
        .onChange(of: id, perform: { newValue in
            check()
        })
        .onChange(of: pass, perform: { newValue in
            check()
        })
        .padding()
    }
    
    func login() {

        launchModel.login(id: id, pass: pass)
        
    }
    
    func check() {
        if id.isEmpty {
            isDisableConfirm = true
            return
        }
        
        if pass.isEmpty {
            isDisableConfirm = true
            return
        }
        
        if id.count < 4 {
            isDisableConfirm = true
            return
        }
        
        isDisableConfirm = false
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
