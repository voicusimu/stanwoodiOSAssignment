//
//  DetailsPresenter.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import Foundation
import UIKit

protocol DetailsViewDelegate: NSObjectProtocol {
    func showDetails(for model: RepositoriesModel.RepoItem)
    func openGitHubPage(for model: RepositoriesModel.RepoItem)
}

class DetailsPresenter {
    weak private var detailsViewDelegate: DetailsViewDelegate?
    private var model: RepositoriesModel.RepoItem

    init(trendingRepositoryModel: RepositoriesModel.RepoItem) {
        self.model = trendingRepositoryModel
    }

    func setViewDelegate(detailsViewDelegate: DetailsViewDelegate?) {
        self.detailsViewDelegate = detailsViewDelegate
    }

    func showDetails() {
        detailsViewDelegate?.showDetails(for: model)
    }

    func openGitHubPage() {
        detailsViewDelegate?.openGitHubPage(for: model)
    }
}
