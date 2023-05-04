//
//  HomeView.swift
//  tempo
//
//  Created by VegaPunk on 25/04/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Image(systemName: "house")
                .frame(width: 500.0, height: 500.0)
                .border(.black)
            HStack {
                TextField("Rechercher", text: $searchText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                
                Button(action: {
                    // Action pour effacer le texte de recherche
                    searchText = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                })
                .padding(.trailing, 10)
                .opacity(searchText == "" ? 0 : 1)
//                .animation(.default)
            }
//            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color(.systemBackground))
            
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
