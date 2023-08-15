//
//  PhotoRequestResponse.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import Foundation

/// Refer to: https://www.pexels.com/api/documentation/#introduction for more info.

/// A photos request response from Pexels.com
struct PhotoRequestResponse {
    /// The page index for the response
    let page: Int
    /// How many photos are in the current page
    let perPage: Int
    let photos: [Photo]
    
    let nextPageURL: URL?
    let previousPageURL: URL?
}

extension PhotoRequestResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case nextPageURL = "next_page"
        case previousPageURL = "prev_page"
    }
}
