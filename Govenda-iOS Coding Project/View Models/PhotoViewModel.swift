//
//  PhotoViewModel.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/15/23.
//

import UIKit


@dynamicMemberLookup
class PhotoViewModel {
    private let photo: Photo
    private let photoProvider: PhotoProvider

    var thumbnail: UIImage? {
        get async throws {
            let imageData = try Data(contentsOf: self.photo.imageURLs.tiny)

            return UIImage(data: imageData)
        }
    }

    /// Gets the average color of the photo as a `UIColor`
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

    var sizeText: String {
        "\(photo.width) x \(photo.height)"
    }

    func getOriginalSizeImage() async -> UIImage? {
        do {
            async let imageData = photoProvider.fetch(photo: photo, size: .original)

            return await UIImage(data: try imageData)

        } catch {
            print(error)

            return nil
        }
    }

    init(_ photo: Photo, provider: PhotoProvider) {
        self.photo = photo
        self.photoProvider = provider
    }

    subscript<MemberType>(dynamicMember keyPath: KeyPath<Photo, MemberType>) -> MemberType {
        photo[keyPath: keyPath]
    }
}
