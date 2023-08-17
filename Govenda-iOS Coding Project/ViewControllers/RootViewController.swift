//
//  RootViewController.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import UIKit
import Combine


class RootViewController: UISplitViewController {
    private var detailNavigationController: UINavigationController? = nil
    private var compactNavigationController: UINavigationController? = nil
    private var photoDetailViewController = PhotoDetailViewController(photoViewModel: nil)
    var viewModel: RootViewModel

    private var cancelBag: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainViewController = PhotosMainViewController(viewModel: viewModel.mainViewModel, isHorizontalCompact: false)
        let mainCompactViewController = PhotosMainViewController(viewModel: viewModel.mainViewModel, isHorizontalCompact: true)
        detailNavigationController = UINavigationController(rootViewController: photoDetailViewController)
        compactNavigationController = UINavigationController(rootViewController: mainCompactViewController)
        setViewController(mainViewController, for: .primary)
        setViewController(detailNavigationController, for: .secondary)
        setViewController(compactNavigationController, for: .compact)

        viewModel.$detailViewModel.assign(to: \.viewModel, on: photoDetailViewController)
            .store(in: &cancelBag)
    }

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel

        super.init(style: .doubleColumn)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
