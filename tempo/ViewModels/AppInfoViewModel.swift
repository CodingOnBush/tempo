//
//  AppInfoViewModel.swift
//  tempo
//
//  Created by VegaPunk on 23/04/2023.
//

import Foundation
import Combine

//class AppInfoViewModel: ObservableObject {
//    
//    @Published var appDetails: AppDetails?
//    @Published var isLoading = false
//    @Published var error: Error?
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    func fetchAppInfo(appID: String) {
//        isLoading = true
//        error = nil
//        
//        AppStoreAPI.fetchAppInfo(appID: appID) { result in
//            print("I'm on fetchAppInfo method call")
//            DispatchQueue.main.async {
//                self.isLoading = false
//                switch result {
//                case .success(let appInfo):
//                    self.appDetails = appInfo.results.first
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//}
