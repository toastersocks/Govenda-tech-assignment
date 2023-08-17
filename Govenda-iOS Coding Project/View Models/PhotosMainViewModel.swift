//
//  PhotosMainViewModel.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import UIKit


class PhotosMainViewModel: ObservableObject {
    private let photoProvider: PhotoProvider

    @Published private(set)
    var photos: [PhotoViewModel] = []

    @Published
    var selectedPhoto: PhotoViewModel? = nil
    var title = "Select a photo"

    init(photoProvider: PhotoProvider) {
        self.photoProvider = photoProvider
    }

    func refreshPhotos(page: Int, photosPerPage: Int) {
        Task.detached { @MainActor [weak self, photoProvider] in
            guard let self else { return }
            
            self.photos = try await photoProvider.curatedPhotos(page: page, photosPerPage: photosPerPage)
                .map {
                    PhotoViewModel($0, provider: photoProvider)
                }
        }
    }

    subscript(_ photoIndex: Int) -> PhotoViewModel {
        photos[photoIndex]
    }
}
