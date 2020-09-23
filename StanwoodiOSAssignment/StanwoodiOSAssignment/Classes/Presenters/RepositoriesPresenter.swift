//
//  RepositoriesPresenter.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import Foundation

protocol RepositoriesViewDelegate: NSObjectProtocol {
    func displayTrendingRepositories(repositories: [RepositoriesModel.RepoItem])
}

class RepositoriesPresenter {
    private let trendingRepositoriesService: TrendingRepositoriesService
    weak private var trendingRepositoriesDelegate: RepositoriesViewDelegate?

    init(trendingRepositoriesService: TrendingRepositoriesService) {
        self.trendingRepositoriesService = trendingRepositoriesService
    }

    func setViewDelegate(trendingRepositoriesDelegate: RepositoriesViewDelegate?) {
        self.trendingRepositoriesDelegate = trendingRepositoriesDelegate
    }

    func trendingRepositories(with interval: IntervalType, page: Int) {
        trendingRepositoriesService.getTrendingRepositories(interval: interval, page: page) { [weak self] (items) in
            self?.trendingRepositoriesDelegate?.displayTrendingRepositories(repositories: items)
        }
    }
}
