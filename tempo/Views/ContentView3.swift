//
//  ContentView3.swift
//  tempo
//
//  Created by VegaPunk on 01/06/2023.
//

import SwiftUI

enum BtnState {
    case idle
    case loading
    case done
}

struct ContentView3: View {
    @State private var isActive = false
    @State private var buttonState: BtnState = .idle

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                buttonState = .loading
            }
        }) {
            ZStack {
                Color.blue
                switch buttonState {
                case .idle:
                    Text("Save app")
                        .font(.title)
                        .foregroundColor(.white)
                case .loading:
                    ProgressView()
                        .tint(.white)
                case .done:
                    Label("Saved", systemImage: "checkmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .cornerRadius(8)
        }
        .onAppear {
            isActive = true
        }
        .onDisappear {
            isActive = false
        }
        .onChange(of: buttonState) { newValue in
            if newValue == .loading {
                // save l'app
            } else if newValue == .done {
                // vibration
                // wait 1scd
                // fermé la popup
            }
        }
    }
}

struct ContentView3_Previews: PreviewProvider {
    static var previews: some View {
        ContentView3()

    }
}
