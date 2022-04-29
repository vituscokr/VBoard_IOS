//
//  CouponBarCodeView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/28.
//

import SwiftUI
import LSSLibrary


struct CouponBarCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var barcode :String = "abcd"
    var body: some View {
        ZStack {
            
            Color.red
            
            VStack{
                ZStack {
                    Image("_coupon img")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 343, height: 488, alignment: .center)
                    
                    VStack (spacing:24){
                        Image("footer_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:103, height:19, alignment: .center)
                        VStack(spacing:8) {
                            BarCodeCode128View(barcode: barcode)
                                .frame(width: 279, height: 108, alignment: .center)
                            
                            Text(barcode)
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(Color.black) //graydark1
                        }
                        Spacer()
                    
                    }
                    .padding(.top, 56 )
                    
                    VStack (spacing: 24){
                        Spacer()
                        
                        VStack(spacing:4) {
                        Text("금액원")
                            .font(.system(size: 32, weight: .bold, design: .default))
                            .foregroundColor(Color.pink) //mainpink
                        Text("쿠폰제목")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(Color.gray) //graydark3
                        }
                        
                        VStack(spacing: 9) {
                            Text("오프라인 사용처")
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .foregroundColor(Color.gray) //mainpink_dark
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.pink) //Color.pinklight2
                                        .padding(.horizontal, -12)
                                        .padding(.vertical, -3)
                                }

                            
                            Text("사용처1, 사용처2, 사용처3")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(Color.gray) //darkgray2
                            
                            
                        }
                        
                        
                    }
                    .padding(.bottom, 24)
                    
                    
                }
                .frame(width: 343, height: 488, alignment: .center)
               
                
            }
            
            VStack {
                
                Spacer()
                
                Button(action: close){
                    EmptyView()
                }
                .buttonStyle(LSSButtonStyle(change: { status in
                    
                    Image("barcode_close")
                        .resizable()
                        .scaledToFit()
                        .frame(width:48, height: 48, alignment: .center)
                    
                }))
                .padding(.bottom, 80)
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    func close() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CouponBarCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CouponBarCodeView()
    }
}
