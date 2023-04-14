//
//  LoadingView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/14/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    
       var body: some View {
           ZStack {
    
               Text("Loading")
                   .font(.system(.body, design: .rounded))
                   .bold()
                   .offset(x: 0, y: -25)
    
               RoundedRectangle(cornerRadius: 3)
                   .stroke(Color(.systemGray5), lineWidth: 3)
                   .frame(width: 250, height: 3)
    
               RoundedRectangle(cornerRadius: 3)
                   .stroke(Color(red: 30/255, green: 65/255, blue: 105/255), lineWidth: 3)
                   .frame(width: 30, height: 3)
                   .offset(x: isLoading ? 110 : -110, y: 0)
                   .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
           }
           .onAppear() {
               self.isLoading = true
           }
       }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
