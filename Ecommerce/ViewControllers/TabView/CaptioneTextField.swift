//
//  CaptioneTextField.swift
//  Frippy_finall
//
//  Created by Mac Mini 6 on 17/5/2023.
//

import Foundation

import SwiftUI

struct CaptionedTextField: View {

    let caption: String

    @Binding var text: String

    let placeholder: String

    var body: some View {

        GeometryReader { geometry in

            VStack {

                HStack {

                    Text(caption)

                        .font(.system(size: 15, weight: .medium))

                        .foregroundColor(.black)

                    Spacer()

                }

                .frame(width: 310)

                

                TextField(placeholder, text: $text)

                    .padding()

                    .frame(width: 310, height: 50)

                    .background(.black.opacity(0.05))

                    .cornerRadius(12)

                    .disableAutocorrection(true)

            }

            .frame(width: geometry.size.width) // Align center

        } // End of Geometry Reader

        .frame(height: 100)

    }

}



struct CaptionedTextField_Previews: PreviewProvider {

    static var previews: some View {

        CaptionedTextField(caption: "Username", text: .constant(""), placeholder: "Enter username")

    }

}
