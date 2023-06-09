//
//  AppLibrary.swift
//  tempo
//
//  Created by VegaPunk on 01/06/2023.
//

import SwiftUI

struct AppLibrary: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = AppViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            if viewModel.apps.count == 0 {
                Text("tuto add app")
            } else {
                List {
                    ForEach(viewModel.apps) { item in
                        NavigationLink {
                            Text("new view")
                        } label: {
                            HStack {
                                Image(uiImage: item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                Text(item.name)
                                    .font(.system(.title3, design: .rounded))
                                    .bold()
                            }
                        }
                        .padding(.horizontal, 0)
                    }
                    .onDelete(perform: viewModel.deleteItems(offsets:))
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        EditButton()
                        Button {
                            self.viewModel.emptyLocalStorage()
                        } label: {
                            Label("Clean Core Data Storage", systemImage: "trash")
                        }
                    }
                }
                .navigationTitle("Your apps")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                viewModel.fetchData()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
}

struct AppLibrary_Previews: PreviewProvider {
    static var previews: some View {
        AppLibrary()
    }
}
