//
//  AddingAppView.swift
//  sharetempo
//
//  Created by VegaPunk on 06/05/2023.
//

import SwiftUI

struct AddingAppView: View {
    @StateObject var app: AppModel
    
    var body: some View {
        ZStack {
            Color(red: 0.89, green: 0.89, blue: 0.89)
                .ignoresSafeArea()
            VStack {
//                Text("print : \(toPrint)")
                HStack {
                    self.app.appIcon?
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(self.app.name ?? "app name")
                            .font(.headline)
                        Text(self.app.appstoreURL?.absoluteString ?? "no url fz§7 ound")
                            .font(.subheadline)
                    }
                    .padding(.leading, 16)
                }
                .padding(18)
                .background(Color.white)
                .cornerRadius(8)
            }
        }
    }
}
