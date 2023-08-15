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

@dynamicMemberLookup
class PhotoViewModel {
    private let photo: Photo
    var thumbnail: UIImage? {
        get async throws {
            let imageData = try Data(contentsOf: self.photo.imageURLs.tiny)

            return UIImage(data: imageData)
        }
    }

    var averageColor: UIColor {
        let hex = String(photo.averageColor.trimmingPrefix(/#/))

        guard hex.count == 6 else { return .clear }

        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else { return .clear }

        let red, green, blue: CGFloat

        red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        blue = CGFloat((hexNumber & 0x0000ff)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    init(_ photo: Photo) {
        self.photo = photo
    }

    subscript<MemberType>(dynamicMember keyPath: KeyPath<Photo, MemberType>) -> MemberType {
        photo[keyPath: keyPath]
    }
}
