//
//  PhotoProvider.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import Foundation


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
            let json = String(decoding: data, as: UTF8.self)
            print(json)
            print(response)

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
}
