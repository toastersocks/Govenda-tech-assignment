//
//  PhotoDetailViewController.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/15/23.
//

import UIKit


class PhotoDetailViewController: UIViewController {
    var viewModel: PhotoViewModel? {
        didSet {
            Task.detached {
                await self.refresh(withViewModel: self.viewModel)
            }
        }
    }
    let photoImageView = UIImageView()


    init(photoViewModel: PhotoViewModel?) {
        self.viewModel = photoViewModel

        super.init(nibName: nil, bundle: nil)
    }

    @MainActor
    func refresh(withViewModel viewModel: PhotoViewModel?) async {
        guard let viewModel else { photoImageView.image = nil; return }
        photoImageView.image = await viewModel.getOriginalSizeImage()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: photoImageView.trailingAnchor, multiplier: 1),
            photoImageView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: photoImageView.bottomAnchor, multiplier: 1),
        ])
    }
}
