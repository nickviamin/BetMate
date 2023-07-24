//
//  InputField.swift
//  BetMate
//
//  Created by Nick Viamin on 7/23/23.
//

import SwiftUI

struct InputField: View {
    let imageName: String
    let placeholderText: String
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                TextField(placeholderText, text: $text)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            Divider()
                .background(Color(.darkGray))
        }
        .padding(.horizontal, 20)
        .cornerRadius(8)
        .navigationBarHidden(true)
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(imageName: "envelope", placeholderText: "Email", text: .constant(""))
    }
}
