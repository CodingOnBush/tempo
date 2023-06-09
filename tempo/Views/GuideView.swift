//
//  GuideView.swift
//  tempo
//
//  Created by VegaPunk on 09/06/2023.
//

import SwiftUI

struct GuideView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("How to save apps")
                .font(.largeTitle)
                .bold()
            
            ZStack {
                Color.gray
            }
            .frame(height: 500)
            .cornerRadius(16)
            
            Text("Pour enregistrer une application, vous pouvez vous rendre sur la page App Store de l'application et utiliser le bouton de partage.")
                .padding(.top, 16)
            
            Spacer()
        }
        .padding()
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView()
    }
}
