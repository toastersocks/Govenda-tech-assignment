//
//  RootViewController.swift
//  Govenda-iOS Coding Project
//
//  Created by James Pamplona on 8/14/23.
//

import UIKit
import Combine


class RootViewController: UISplitViewController {
    var detailNavigationController: UINavigationController? = nil
    var photoDetailViewController = PhotoDetailViewController(photoViewModel: nil)
    var viewModel: RootViewModel

    private var cancelBag: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()


        detailNavigationController = UINavigationController(rootViewController: photoDetailViewController)

        setViewController(PhotosMainViewController(viewModel: viewModel.mainViewModel), for: .primary)
        setViewController(detailNavigationController, for: .secondary)

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
