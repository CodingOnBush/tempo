//
//  AddingAppView.swift
//  sharetempo
//
//  Created by VegaPunk on 06/05/2023.
//

import SwiftUI
import CoreData

struct AddingAppView: View {
    @StateObject var app: AppModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            Color(red: 0.89, green: 0.89, blue: 0.89)
                .ignoresSafeArea()
            VStack {
                HStack {
                    ZStack {
                        Rectangle().foregroundColor(.gray)
                        self.app.appIcon?.resizable()
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(self.app.trackName ?? "app name")
                            .font(.headline)
                        Text("\(self.app.trackId ?? 0)")
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
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
