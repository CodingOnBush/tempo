//
//  AppInfoView.swift
//  tempo
//
//  Created by VegaPunk on 23/04/2023.
//

import SwiftUI

//struct AppInfoView: View {
//    let stringAppId: String
//    @ObservedObject var viewModel = AppInfoViewModel()
//    
//    var body: some View {
//        VStack {
//            if let appDetails = viewModel.appDetails {
//                Text(appDetails.trackName ?? "no app trackname")
//                    .font(.title)
//                Text(appDetails.description ?? "no app description")
//                    .font(.subheadline)
//            } else if viewModel.isLoading {
//                ProgressView()
//            } else {
//                Text("Failed to load data")
//            }
//        }
//        .padding()
//        .onAppear {
//            viewModel.fetchAppInfo(appID: stringAppId)
//        }
//    }
//}
//
//struct AppInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppInfoView(stringAppId: "12894719846819")
//    }
//}
