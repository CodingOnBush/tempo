//
//  LargeButtonView.swift
//  tempo
//
//  Created by VegaPunk on 09/06/2023.
//

import SwiftUI

struct LargeButtonView: View {
    let buttonTitle: String
    let iconSystemName: String
    let buttonColorHex: String
    let buttonAction: () -> Void
    
    /**
     L'annotation @escaping est utilisée pour indiquer qu'une fermeture (closure) est autorisée à s'échapper de la portée de la fonction où elle est déclarée, c'est-à-dire qu'elle peut être stockée et utilisée en dehors de cette portée.
     **/
    init(buttonTitle: String, iconSystemName: String, buttonColorHex: String, buttonAction: @escaping () -> Void) {
        self.buttonTitle = buttonTitle
        self.iconSystemName = iconSystemName
        self.buttonAction = buttonAction
        self.buttonColorHex = buttonColorHex
    }
    
    init(buttonTitle: String, buttonColorHex: String, buttonAction: @escaping () -> Void) {
        self.buttonTitle = buttonTitle
        self.iconSystemName = ""
        self.buttonAction = buttonAction
        self.buttonColorHex = buttonColorHex
    }
    
    var body: some View {
        ZStack {
            Color(hex: buttonColorHex)
            HStack {
                if iconSystemName != "" {
                    Image(systemName: iconSystemName)
                }
                Button(buttonTitle, action: buttonAction)
            }
        }
        .modifier(LargeButtonModifier())
    }
}

struct LargeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LargeButtonView(buttonTitle: "Button name", buttonColorHex: "36A4E2") {
            print("btn pressed")
        }
        .previewLayout(.sizeThatFits)
        
        LargeButtonView(buttonTitle: "Button name", iconSystemName: "house", buttonColorHex: "36A4E2") {
            print("btn pressed")
        }
        .previewLayout(.sizeThatFits)
    }
}

struct LargeButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .foregroundColor(.white)
            .fontWeight(.bold)
            .cornerRadius(8)
    }
}
