//
//  PhotosMainViewController.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import UIKit
import Combine


private let reuseIdentifier = "Cell"

class PhotosMainViewController: UICollectionViewController {
    var viewModel: PhotosMainViewModel
    let isHorizontalCompact: Bool


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        title = viewModel.title
        viewModel.refreshPhotos(page: 1, photosPerPage: 80)

        Task.detached { @MainActor in
            for try await _ in self.viewModel.$photos.values {
                self.collectionView.reloadData()
            }
        }
    }

    init(viewModel: PhotosMainViewModel, isHorizontalCompact: Bool) {
        self.viewModel = viewModel
        self.isHorizontalCompact = isHorizontalCompact

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let model = viewModel[indexPath.item]
        let imageView = UIImageView()
        imageView.accessibilityLabel = model.altText

        // Make the background of the image the average color of the photo for a nice effect while the image is being loaded.
        imageView.backgroundColor = model.averageColor

        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: cell.contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
        Task.detached { @MainActor in
            imageView.image = try? await model.thumbnail
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedPhoto = viewModel[indexPath.item]
        if isHorizontalCompact {
            navigationController?.show(PhotoDetailViewController(photoViewModel: viewModel.selectedPhoto), sender: self)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
