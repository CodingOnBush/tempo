//
//  RecentlyAdded.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI

struct RecentlyAdded: View {
    var apps: [AnApp]
    var seeMoreAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Recently added")
                    .font(.title2)
                
                Spacer()
                
                Button {
                    print("btn pressed")
                    seeMoreAction()
                } label: {
                    Text("see more")
                        .underline()
                }

            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment:.leading) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(self.apps) { currentApp in
                            NavigationLink(destination: {
                                Text("view !")
                            } ) {
                                LittleAppCell(app: currentApp)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RecentlyAdded_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyAdded(apps: AnApp.sampleApps, seeMoreAction: {})
            .previewLayout(.sizeThatFits)
    }
}
