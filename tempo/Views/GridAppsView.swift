//
//  GridAppsView.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI

struct GridAppsView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @ObservedObject var vm: AppViewModel

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Text("Your apps")
                        .font(.largeTitle)
                        .padding()
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(self.vm.apps) { item in
                                NavigationLink {
                                    Text("details")
                                } label: {
                                    VStack {
                                        ZStack {
                                            Image(uiImage: item.icon)
                                                .resizable()
                                        }
                                        .cornerRadius(16)
                                        .frame(height: squareSize(for: geometry))
                                        
                                        Text(item.name)
                                            .lineLimit(1)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                    .frame(width: squareSize(for: geometry))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    func squareSize(for geometry: GeometryProxy) -> CGFloat {
        let totalSpacing: CGFloat = 16 * 2 + 8 * 3 // Paddings (16) + Spacing (8) between columns
        let availableWidth = geometry.size.width - totalSpacing
        let squareSize = availableWidth / 4
        return squareSize
    }
}

struct GridAppsView_Previews: PreviewProvider {
    static var previews: some View {
        GridAppsView(vm: AppViewModel())
    }
}
