//
//  BoardAddView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/29.
//

import SwiftUI

struct BoardAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model : BoardModel
    @State var subject = ""
    @State var content = ""
    var body: some View {
        VStack {
            TextField("", text: $subject )
                .padding()
                .border(Color.gray, width: 1)
            TextEditor(text: $content)
                .padding()
                .border(Color.gray, width: 1)
            Spacer()
            Button(action : {
                
                let board = Board(id: 0, subject: subject, content: content)
                model.add(board: board)
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("저장")
            }
            
            .padding()
            
           
        }
        
       
    }
}

struct BoardAddView_Previews: PreviewProvider {
    static var previews: some View {
        BoardAddView()
    }
}
