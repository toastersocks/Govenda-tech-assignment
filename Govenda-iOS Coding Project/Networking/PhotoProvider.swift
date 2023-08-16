//
//  PhotoProvider.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import Foundation


/// Provides Photos from the Pexels API
class PhotoProvider {
    private let apiBaseURL: URL
    private let urlSession: URLSession

    init?(apiKey: String? = nil) {
        guard let apiKey = apiKey ?? Bundle.main.infoDictionary?["PhotoAPIKey"] as? String,
        let apiBaseURL = URL(string: "https://api.pexels.com/v1/") else { return nil }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "Authorization": apiKey,
        ]

        self.apiBaseURL = apiBaseURL
        self.urlSession = URLSession(configuration: sessionConfig)
    }

    private func curatedPhotosJSON(page: Int, photosPerPage: Int) async throws -> Data {

        let curatedURL = apiBaseURL
            .appending(component: "curated")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(photosPerPage)"),
            ])

        do {
            let (data, response) = try await self.urlSession.data(from: curatedURL)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(statusCode) else { return "".data(using: .utf8)! }

            return data

        } catch {
            print(error)
            throw error
        }
    }


    /// Get curated photos from Pexels
    /// - Parameters:
    ///   - page: The page index of the photos to return
    ///   - photosPerPage: The number of photos to return per page.
    /// - Returns: An array of photo instances.
    func curatedPhotos(page: Int, photosPerPage: Int) async throws -> [Photo] {
        let json = try await curatedPhotosJSON(page: page, photosPerPage: photosPerPage)

        do {
            let photos = try JSONDecoder().decode(PhotoRequestResponse.self, from: json).photos

            return photos
        } catch {
            print(error)
            throw error
        }
    }



    /// Fetches image data for a photo size from a `Photo`.
    /// - Parameters:
    ///   - photo: The `Photo` to retrieve data for.
    ///   - size: The size to fetch.
    /// - Returns: Data for a photo size.  If the data could not be retrieved, the data will be empty
    func fetch(photo: Photo, size: PhotoSize) async throws -> Data {
        let sizeURL: URL
        switch size {
        case .original:
            sizeURL = photo.imageURLs.original
        case .large:
            sizeURL = photo.imageURLs.large
        case .large2x:
            sizeURL = photo.imageURLs.large2x
        case .medium:
            sizeURL = photo.imageURLs.medium
        case .small:
            sizeURL = photo.imageURLs.small
        case .portrait:
            sizeURL = photo.imageURLs.portrait
        case .landscape:
            sizeURL = photo.imageURLs.landscape
        case .tiny:
            sizeURL = photo.imageURLs.tiny
        }
        let (data, response) = try await urlSession.data(from: sizeURL)

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
        (200...299).contains(statusCode) else { return Data() }

        return data
    }

    enum PhotoSize {
        case original
        case large
        case large2x
        case medium
        case small
        case portrait
        case landscape
        case tiny
    }
}
