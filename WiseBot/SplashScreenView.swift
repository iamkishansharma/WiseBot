//
//  SplashScreenView.swift
//  WiseBot
//
//  Created by Kishan Kr Sharma on 12/23/22.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var size = 0.7
    @State private var opacity = 0.4
    
    var body: some View {
        if isActive {
            // load main screen after isActive set to true
            ContentView()
        }else{
            ZStack{
                LinearGradient(colors: [.black, .black], startPoint: .zero, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center){
                    Spacer()
                    Image("wisebot")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width/1.1)
                    Spacer()
                    Text("Build with ❤️\nby")
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .purple, radius: 10)
                    
                    Text("Kishan Kr Sharma")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .purple, radius: 10)
                }
                .padding()
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeInOut(duration: 1.5)){
                        self.size = 1.1
                        self.opacity = 1.0
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
