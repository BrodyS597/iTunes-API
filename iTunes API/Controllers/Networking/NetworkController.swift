//
//  NetworkController.swift
//  iTunes API
//
//  Created by Brody Sears on 2/11/22.
//

import Foundation
import UIKit.UIImage

class NetworkController {
    // MARK: -URL
    static let baseURL = URL(string: "https://itunes.apple.com")
    
    // MARK: -Fetch Album Func
    static func fetchAlbumWith(searchTerm: String, completion: @escaping (Result<TopLevelDictionaryAlbums, ResultError>) -> Void) {
        
        guard let url = baseURL else { return }
        let searchKey = URLQueryItem(name: "term", value: searchTerm)
        let mediaKey = URLQueryItem(name: "media", value: "music")
        let entityKey = URLQueryItem(name: "entity", value: "album")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/search"
        urlComponents?.queryItems = [searchKey, mediaKey, entityKey]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL("Unable to reach the server. Please try again")))
            return }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let data = try JSONDecoder().decode(TopLevelDictionaryAlbums.self, from: data)
                
                completion(.success(data))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    // MARK: -Fetch Album Details func
    static func fetchTracks(with albumID: String, completion: @escaping (Result<[Track], ResultError>) -> Void) {
        
        guard let url = baseURL else { return }
        let lookUpKey = URLQueryItem(name: "id", value: albumID)
        let entityKey = URLQueryItem(name: "entity", value: "song")
        let kindKey = URLQueryItem(name: "kind", value: "song")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/lookup"
        urlComponents?.queryItems = [lookUpKey, kindKey, entityKey]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.invalidURL("Unable to reach the server. Please try again")))
            return }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let data = try JSONDecoder().decode(TopLevelDictionaryAlbumDetails.self, from: data)
                // filters through the array to find which track's value in the array == "song" and completes with those
                let trackArray = data.results.filter { $0.kind == "song" }
                completion(.success(trackArray))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    // MARK: -Fetch Album Image Func
    static func fetchAlbumImage(with albumImageString: String, completion: @escaping (Result<UIImage, ResultError>) -> Void) {
        
        guard let imageURL = URL(string: albumImageString) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("There was an error fetching the image", error.localizedDescription)
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let albumImage = UIImage(data: data) else {
                completion(.failure(.unableToDecode))
                return
            }
            completion(.success(albumImage))
        }.resume()
    }
}//End of class
