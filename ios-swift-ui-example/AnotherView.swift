//
//  AnotherView.swift
//  ios-swift-ui-example
//
//  Created by Michael Howard on 2023/01/19.
//

import SwiftUI

struct AnotherView: View {
    
    @Binding var selection: Int?
    
    var body: some View {
        VStack {
            Text("You navigated!")
            
        }.background(
            Image("app-background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        .onAppear(perform: initialize)
    }
    
    private func initialize() {
        selection = nil
    }
}

//struct AnotherView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnotherView(nil)
//    }
//}
