//
//  RootViewModel.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/16/23.
//

import Foundation


class RootViewModel {
    let photoProvider: PhotoProvider
    let mainViewModel: PhotosMainViewModel
    @Published
    var detailViewModel: PhotoViewModel? = nil

    init(photoProvider: PhotoProvider? = nil) {
        guard let photoProvider = photoProvider ?? PhotoProvider() else { preconditionFailure("Make sure you've set up an api key in APIKey.xcconfig or pass an api key to the PhotoProvider initializer.") }

        self.photoProvider = photoProvider
        self.mainViewModel = PhotosMainViewModel(photoProvider: photoProvider)

        Task.detached { [weak self] in
            guard let self else { return }

            await self.updatePhoto()
        }
    }

    func updatePhoto() async {
        for await photo in mainViewModel.$selectedPhoto.values {
            detailViewModel = photo
        }
    }
    
}
