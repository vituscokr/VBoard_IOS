//
//  BarcodeView.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/28.
//

import SwiftUI
import LSSLibrary





struct BarcodeView: View {
    var body: some View {

        
        VStack {
            BarCodeCode128View(barcode: "abcd")
                .frame(width: 279, height: 108, alignment: .center)
        }
        
        
    }
}




struct BarcodeView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeView()
    }
}


struct BarCodeCode128View : UIViewRepresentable {
    let barcode: String
    func makeUIView(context: Context) -> UIImageView {
        UIImageView()
    }
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = barcode.generateBarcode()
    }
}


extension String {
    //출처: https://hongssup.tistory.com/93 [Outgoing Introvert]
    //CIFilter(name: "CICode128BarcodeGenerator")
    //CIFilter(name: "CIEANBarcodeGenerator")


    public func generateBarcode() -> UIImage? {
        
        let data = self.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let image = UIImage(ciImage: output)
                Debug.log(image)
                return image
            }
            
        }
        
        return nil
            
    }
}
