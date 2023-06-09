//
//  ShareSheetSwiftUIView.swift
//  sharetempo
//
//  Created by VegaPunk on 03/05/2023.
//

import SwiftUI
import CoreData
import CoreHaptics

enum BtnState {
    case idle
    case loading
    case done
}

struct ShareSheetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var context: NSExtensionContext?
    @StateObject var currentApp = AppModel()
    @State var isValidURL: Bool = false
    @State var isItemSaved = "nooo"
    @State private var buttonState: BtnState = .idle
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer()
                
                VStack {
                    ZStack {
                        Rectangle().foregroundColor(.gray)
                        self.currentApp.appIcon?.resizable()
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(16)
                    .shadow(radius: 5)

                    VStack(alignment: .center, spacing: 5) {
                        Text(self.currentApp.trackName ?? "app name")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(self.currentApp.trackId ?? 0)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 16)
                }
                .padding(18)
                .frame(maxWidth: .infinity)
                .cornerRadius(8)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        buttonState = .loading
                    }
                }) {
                    ZStack {
                        Color.white
                        switch buttonState {
                        case .idle:
                            Text("Save app")
                                .font(.title)
                                .foregroundColor(.black)
                        case .loading:
                            ProgressView()
                                .tint(.black)
                        case .done:
                            Label("Saved", systemImage: "checkmark")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .cornerRadius(8)
                }
                .onChange(of: buttonState) { newValue in
                    if newValue == .loading {
                        // save l'app
                        self.addItem()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            // Put your code which should be executed with a delay here
                            self.buttonState = .done
                        }
                    } else if newValue == .done {
                        // vibration
                        // wait 1scd
                        // fermé la popup
                        self.simpleSuccess()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // Put your code which should be executed with a delay here
                            // fermer la popup
                            self.context?.completeRequest(returningItems: [], completionHandler: nil)
                        }
                    }
                }
            }
            .padding()
        }.onAppear {
            // onAppear triggers actions any time the view appears on screen, even if it’s not the first time.
            self.prepareHaptics()
            self.loadMaxData()
        }.task {
            // task triggers actions that execute asynchronously before the view appears on screen.
            // self.loadMaxData()
        }.onDisappear {
            // onDisappear triggers actions when a view disappears from screen.
        }
        
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    private func addItem() {
        let newItem = AppEntity(context: viewContext)
        newItem.timestamp = Date()
        newItem.appName = self.currentApp.trackName
        newItem.icon = self.currentApp.appIconUIImage!.pngData()
        newItem.id = UUID()

        do {
            try viewContext.save()
            self.isItemSaved = "yesss"
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func loadImage(from url: URL?) {
        if let safeURL = url {
            URLSession.shared.dataTask(with: safeURL) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.currentApp.appIconUIImage = UIImage(data: data)
                    self.currentApp.appIcon = Image(uiImage: UIImage(data: data)!)
                }
            }.resume()
        }
    }
    
    private func fetchAppData(from appURL: URL) {
        if let appID = self.extractIdFromLink(appURL.absoluteString) {
            if let url = URL(string: "https://itunes.apple.com/lookup?id=\(appID)") {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let safeData = data {
                        do {
                            let appInfoDecoded = try JSONDecoder().decode(LookupResult.self, from: safeData)
                            let appDetailsFetched = appInfoDecoded.results.first
                            
                            self.currentApp.trackName = appDetailsFetched?.trackName
                            self.currentApp.description = appDetailsFetched?.description
                            self.currentApp.version = appDetailsFetched?.version
                            self.currentApp.sellerName = appDetailsFetched?.sellerName
                            
                            self.currentApp.artworkUrl512 = appDetailsFetched?.artworkUrl512
                            self.currentApp.trackId = appDetailsFetched?.trackId
                            self.currentApp.primaryGenreName = appDetailsFetched?.primaryGenreName
                            self.currentApp.primaryGenreId = appDetailsFetched?.primaryGenreId
                            self.currentApp.averageUserRating = appDetailsFetched?.averageUserRating
                            
                            self.currentApp.userRatingCount = appDetailsFetched?.userRatingCount
                            self.currentApp.price = appDetailsFetched?.price
                            self.currentApp.sellerUrl = appDetailsFetched?.sellerUrl
                            self.currentApp.screenshotUrls = appDetailsFetched?.screenshotUrls
                            self.currentApp.currentVersionReleaseDate = appDetailsFetched?.currentVersionReleaseDate
                            self.currentApp.currentVersionReleaseDate = appDetailsFetched?.currentVersionReleaseDate
                            
                            self.loadImage(from: self.currentApp.artworkUrl512)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
            }
        }
    }
    
    private func extractIdFromLink(_ link: String) -> String? {
        if let range = link.range(of: "id\\d+", options: .regularExpression) {
            return String(link[range].dropFirst(2))
        }
        return nil
    }
    
    private func loadMaxData() {
        if let safeContext = self.context, let inputItems = safeContext.inputItems as? [NSExtensionItem] {
            for inputItem in inputItems {
                if let attachments = inputItem.attachments {
                    for attachment in attachments {
                        let itemProvider = attachment
                        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                                if let shareURL = url as? URL {
                                    // Do something with the URL
                                    self.currentApp.appstoreURL = shareURL
                                    self.currentApp.isValidURL = shareURL.absoluteString.hasPrefix("https://apps.apple.com")
                                    self.fetchAppData(from: shareURL)
                                    self.isValidURL = shareURL.absoluteString.hasPrefix("https://apps.apple.com")
                                }
                            }
                        }
                        if itemProvider.hasItemConformingToTypeIdentifier("public.image") {
                            itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil) { (image, error) in
                                if let shareImage = image as? UIImage {
                                    // Do something with the image
                                    self.currentApp.appIcon = Image(uiImage: shareImage)
                                }
                            }
                        }
                        // Add more conditions for other data types
                    }
                }
            }
        }
    }
}

