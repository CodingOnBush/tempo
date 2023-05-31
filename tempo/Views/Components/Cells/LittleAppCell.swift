//
//  LittleAppCell.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI

struct LittleAppCell: View {
    var app: AnApp
    
    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: self.app.icon)
                    .resizable()
            }
            .cornerRadius(16)
            .frame(height: 78)
            
            Text(self.app.name.split(separator: ":").first ?? "\(self.app.name)")
                .lineLimit(1)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 78)
    }
}

struct LittleAppCell_Previews: PreviewProvider {
    static var previews: some View {
        LittleAppCell(app: AnApp.sampleApps.first!)
            .previewLayout(.sizeThatFits)
    }
}
