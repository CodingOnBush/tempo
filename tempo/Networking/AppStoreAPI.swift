//
//  AppStoreAPI.swift
//  tempo
//
//  Created by VegaPunk on 23/04/2023.
//

import Foundation

enum AppStoreAPIError: Error {
    case invalidURL
    case noAppID
    case decodingError
    case serverError
    case safeDataError
}

class AppStoreAPI {
    static let baseURL = "https://itunes.apple.com/lookup?id="

    static func fetchAppInfo(from appURL: URL, completion: @escaping (Result<LookupResult, AppStoreAPIError>) -> Void) {
        // Récupérer l'ID de l'application
//        guard let appID = appURL.lastPathComponent.split(separator: "=").last else {
//            completion(.failure(.noAppID))
//            return
//        }
        
        guard let appID = self.extractIdFromLink(appURL.absoluteString) else {
            completion(.failure(.noAppID))
            return
        }
        
//        if let appID = self.extractIdFromLink(appURL.absoluteString) {
//            print("L'identifiant est : \(appID)")
//        } else {
//            print("Impossible de trouver l'identifiant dans le lien.")
//            completion(.failure(.noAppID))
//        }
        
        // Construire l'URL de la requête en utilisant l'ID de l'application
        guard URL(string: "\(baseURL)\(appID)") != nil else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Créer une session URLSession et effectuer une requête GET
        let session = URLSession.shared
        let task = session.dataTask(with: appURL) { data, response, error in
            // Vérifier si une erreur s'est produite
            if error != nil {
                completion(.failure(.serverError))
                return
            }
            
            // Vérifier si des données ont été renvoyées
            guard let safeData = data else {
                completion(.failure(.safeDataError))
                return
            }
            
            // Essayer de décoder les données en utilisant le type AppInfoFetched
            do {
                let decoder = JSONDecoder()
                let appInfoFetched = try decoder.decode(LookupResult.self, from: safeData)
                completion(.success(appInfoFetched))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    static func extractIdFromLink(_ link: String) -> String? {
        if let range = link.range(of: "id\\d+", options: .regularExpression) {
            return String(link[range].dropFirst(2))
        }
        return nil
    }

}
