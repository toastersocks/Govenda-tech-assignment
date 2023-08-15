//
//  Photo.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import Foundation


/// A photo from the Pexels API
struct Photo {
    let photographerName: String
    let photographerURL: String
    let photographerID: Int
    let width: Int
    let height: Int
    let photoID: Int
    /// The URL of the photo on the Pexels website.
    let url: URL
    /// The average color of the photo
    let averageColor: String
    let altText: String
    /// The URLs for the various image sizes
    let imageURLs: ImageSizes
}

extension Photo: Decodable {
    enum CodingKeys: String, CodingKey {
        case photographerName = "photographer"
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case width
        case height
        case photoID = "id"
        case url
        case averageColor = "avg_color"
        case altText = "alt"

        case imageURLs = "src"
    }
}

extension Photo: Identifiable {
    var id: Int {
        photoID
    }
}

struct ImageSizes: Decodable {
    let original: URL
    let large2x: URL
    let large: URL
    let medium: URL
    let small: URL
    let portrait: URL
    let landscape: URL
    let tiny: URL
}
