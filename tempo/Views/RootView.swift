//
//  RootView.swift
//  tempo
//
//  Created by VegaPunk on 26/04/2023.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedTab = "Apps"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                vm: AppViewModel(viewContext: self.viewContext),
                tabSelection: $selectedTab
            )
                .tabItem {
                    Image(systemName: "house")
                    Text("Home4")
                }
                .tag("home")
            
            AppLibrary()
                .tabItem {
                    Image(systemName: "square.split.1x2.fill")
                    Text("Apps")
                }
                .tag("Apps")
            
            TestView(appViewModel: AppViewModel(viewContext: self.viewContext))
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag("test")
            ContentView2()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(3)
            GridAppsView(vm: AppViewModel(viewContext: self.viewContext))
                .tabItem {
                    Label("quatre", systemImage: "1.square.fill")
                }
                .tag("library")
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct FirstView: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Button(action: {
                self.tabSelection = 2 // Passer à la deuxième vue
            }) {
                Text("Go to Second View")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Text("First View")
                .font(.title)
                .padding()
        }
    }
}


//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}


//struct HomeView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @ObservedObject var vm: AppViewModel
//    @Environment(\.scenePhase) var scenePhase
//    @State private var isEditing: Bool = false
//    @Binding var tabSelection: Int
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("Search an app", text: $vm.homeAppSearch, onEditingChanged: { isEditing = $0 })
//                    .textFieldStyle(FSTextFieldStyle(isEditing: isEditing))
//                    .padding(.horizontal, 16)
//                    .padding(.top, 16)
//                
//                Button {
//                    if let safeID = vm.apps.first?.id {
//                        self.vm.removeApp(id: safeID)
//                    }
//                } label: {
//                    Label("delete", systemImage: "xmark.bin.circle")
//                }
//
//                
//                VStack(alignment: .leading) {
//                    HStack(alignment: .center) {
//                        Text("Recently added")
//                            .font(.title2)
//                        Spacer()
////                        NavigationLink {
////                            GridAppsView(apps: self.vm.apps)
////                        } label: {
////                            Text("see more")
////                                .underline()
////                        }
//                        
//                        Button {
//                            self.tabSelection = 2
//                        } label: {
//                            Text("see more")
//                                .underline()
//                        }
//
//                        
//                    }
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(alignment: .top, spacing: 16) {
//                            ForEach(self.vm.apps) { item in
//                                NavigationLink{
//                                    Text("new")
//                                } label: {
//                                    VStack {
//                                        ZStack {
//                                            Image(uiImage: item.icon)
//                                                .resizable()
//                                        }
//                                        .cornerRadius(16)
//                                        .frame(height: 78)
//                                        
//                                        Text(item.name)
//                                            .lineLimit(1)
//                                            .font(.caption)
//                                            .foregroundColor(.primary)
//                                    }
//                                    .frame(width: 78)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding()
//                
//                Spacer()
//            }
//        }
//        .onChange(of: scenePhase) { newPhase in
//            if newPhase == .active {
//                print("Active")
//                self.vm.fetchData()
//            } else if newPhase == .inactive {
//                print("Inactive")
//            } else if newPhase == .background {
//                print("Background")
//            }
//        }
//    }
//}
//
//extension Color {
//    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
//    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
//    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
//    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
//}
//
//
//struct FSTextFieldStyle: TextFieldStyle {
//    /// Whether the user is focused on this `TextField`.
//    var isEditing: Bool
//    
//    func _body(configuration: TextField<_Label>) -> some View {
//        configuration
//            .textFieldStyle(PlainTextFieldStyle())
//            .multilineTextAlignment(.leading)
//            .accentColor(.black)
//            .foregroundColor(.blue)
//            .font(.title3.weight(.semibold))
//            .padding(.vertical, 6)
//            .padding(.horizontal, 8)
//            .background(myBorder)
//            .submitLabel(.search)
//    }
//    
//    var myBorder: some View {
//        RoundedRectangle(cornerRadius: 8)
//            .strokeBorder(
//                Color(red: 0.6, green: 0.6, blue: 0.6),
//                lineWidth: isEditing ? 2 : 1
//            )
//    }
//    
//    var border: some View {
//        RoundedRectangle(cornerRadius: 16)
//            .strokeBorder(
//                LinearGradient(
//                    gradient: .init(
//                        colors: [
//                            Color(red: 163 / 255.0, green: 243 / 255.0, blue: 7 / 255.0),
//                            Color(red: 226 / 255.0, green: 247 / 255.0, blue: 5 / 255.0)
//                        ]
//                    ),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                ),
//                lineWidth: isEditing ? 4 : 2
//            )
//    }
//}
//
