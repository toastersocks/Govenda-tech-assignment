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
    let photographerNameView = UILabel()
    let altTextView = UILabel()
    let sizeView = UILabel()
    lazy var photoInfoStack = UIStackView(arrangedSubviews: [
        altTextView,
        photographerNameView,
        sizeView
    ])

    var imageTopConstraintRegular: NSLayoutConstraint? = nil
    var imageTopConstraintCompact: NSLayoutConstraint? = nil

    init(photoViewModel: PhotoViewModel?) {
        self.viewModel = photoViewModel

        super.init(nibName: nil, bundle: nil)

        Task.detached { [weak self] in
            guard let self else { return }

            await refresh(withViewModel: photoViewModel)
        }
    }

    @MainActor
    func refresh(withViewModel viewModel: PhotoViewModel?) async {
        photoImageView.image = nil
        guard let viewModel else { photoImageView.image = nil; return }

        async let largeImage = viewModel.getOriginalSizeImage()

        altTextView.text = viewModel.altText
        photographerNameView.text = viewModel.photographerName
        sizeView.text = viewModel.sizeText
        photoImageView.backgroundColor = viewModel.averageColor
        photoImageView.image = await largeImage
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        photoImageView.contentMode = .scaleAspectFit
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoInfoStack.translatesAutoresizingMaskIntoConstraints = false
        photographerNameView.translatesAutoresizingMaskIntoConstraints = false
        altTextView.translatesAutoresizingMaskIntoConstraints = false
        sizeView.translatesAutoresizingMaskIntoConstraints = false

        photoInfoStack.axis = .vertical
        photoInfoStack.alignment = .center

        altTextView.adjustsFontForContentSizeCategory = true
        sizeView.adjustsFontForContentSizeCategory = true
        photographerNameView.adjustsFontForContentSizeCategory = true

        view.addSubview(photoImageView)
        view.addSubview(photoInfoStack)

        imageTopConstraintRegular = photoImageView.topAnchor.constraint(equalTo: view.topAnchor)
        imageTopConstraintCompact = photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: photoInfoStack.bottomAnchor),
            photoInfoStack.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter:  view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: photoInfoStack.trailingAnchor, multiplier: 1),
            photoInfoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoInfoStack.topAnchor.constraint(equalToSystemSpacingBelow: photoImageView.bottomAnchor, multiplier: 1)
        ])

        adjustConstraintsForSizeClass()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustConstraintsForSizeClass()
    }

    func adjustConstraintsForSizeClass() {
        if traitCollection.horizontalSizeClass == .compact {
            imageTopConstraintCompact?.isActive = true
            imageTopConstraintRegular?.isActive = false
        } else {
            imageTopConstraintCompact?.isActive = false
            imageTopConstraintRegular?.isActive = true
        }
    }
}
