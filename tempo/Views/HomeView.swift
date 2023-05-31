//
//  HomeView.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.scenePhase) var scenePhase
    @State var appSearch: String = ""
    //    Whether the user is focused on this `TextField`.
    @State private var isEditing: Bool = false
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search an app", text: $appSearch, onEditingChanged: { isEditing = $0 })
                    .textFieldStyle(FSTextFieldStyle(isEditing: isEditing))
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .submitLabel(.search)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Recently added")
                            .font(.title2)
                        Spacer()
                        Button {
                            print("btn pressed")
                        } label: {
                            Text("see more")
                                .underline()
                        }
                        
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            ForEach(self.appViewModel.apps) { item in
                                NavigationLink{
                                    Text("new")
                                } label: {
                                    withAnimation {
                                        LittleAppCell(app: item)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                self.appViewModel.fetchData()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(appViewModel: AppViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
}

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}


struct FSTextFieldStyle: TextFieldStyle {
    /// Whether the user is focused on this `TextField`.
    var isEditing: Bool
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .textFieldStyle(PlainTextFieldStyle())
            .multilineTextAlignment(.leading)
            .accentColor(.black)
            .foregroundColor(.blue)
            .font(.title3.weight(.semibold))
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(myBorder)
    }
    
    var myBorder: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(
                Color(red: 0.6, green: 0.6, blue: 0.6),
                lineWidth: isEditing ? 2 : 1
            )
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
                LinearGradient(
                    gradient: .init(
                        colors: [
                            Color(red: 163 / 255.0, green: 243 / 255.0, blue: 7 / 255.0),
                            Color(red: 226 / 255.0, green: 247 / 255.0, blue: 5 / 255.0)
                        ]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: isEditing ? 4 : 2
            )
    }
}
