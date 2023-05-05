//
//  LocationTextField.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//
import SwiftUI
import Foundation

struct ComponentLocationTextFieldView: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            TextField(label, text: $text)
                .padding(.all, 7)
                .background(Color("TextField"))
                .cornerRadius(10)
                .autocapitalization(UITextAutocapitalizationType.words)
                .disableAutocorrection(true)
                
                
        }
    }
}



struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
