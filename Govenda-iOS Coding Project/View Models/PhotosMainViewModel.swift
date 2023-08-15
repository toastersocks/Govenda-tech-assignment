//
//  PhotosMainViewModel.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import UIKit


class PhotosMainViewModel: ObservableObject {
    private let photosProvider: PhotoProvider

    @Published private(set)
    var photos: [PhotoViewModel] = []

    init() {
        guard let photosProvider = PhotoProvider() else { preconditionFailure("Make sure you've set up an api key in APIKey.xcconfig or pass an api key to the PhotoProvider initializer.") }

        self.photosProvider = photosProvider
    }

    func refreshPhotos(page: Int, photosPerPage: Int) {
        Task.detached { @MainActor in
            self.photos = try await self.photosProvider.curatedPhotos(page: page, photosPerPage: photosPerPage)
                .map(PhotoViewModel.init)
        }
    }

    subscript(_ photoIndex: Int) -> PhotoViewModel {
        photos[photoIndex]
    }
}
