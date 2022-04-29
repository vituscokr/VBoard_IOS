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
    
    var item : Board?
    
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
                
                
                if item == nil {
                
                    let board = Board(id: 0, subject: subject, content: content)
                model.add(board: board)
                }else {
                    guard  let id = item?.id else {
                        return 
                    }
                    let board = Board(id: id,
                                      subject : subject,
                                      content: content)
                    model.update(board: board)
                }
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("저장")
            }
            
            .padding()
            
           
        }
        .onAppear(perform: load)
        
       
    }
    
    func load() {
        
        if item != nil {
            
            guard let item = item else {
                return
            }
            subject = item.subject
            content = item.content
        }
    }
}

struct BoardAddView_Previews: PreviewProvider {
    static var previews: some View {
        BoardAddView()
    }
}
