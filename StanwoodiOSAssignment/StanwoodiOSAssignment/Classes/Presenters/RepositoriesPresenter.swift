//
//  RepositoriesPresenter.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import Foundation

protocol RepositoriesViewDelegate: NSObjectProtocol {
    func didLoadInitialRepositories(repositories: [RepositoriesModel.RepoItem], hasError: Bool)
    func didLoadMoreRepositories(repositories: [RepositoriesModel.RepoItem], hasError: Bool)
}

class RepositoriesPresenter {
    private let trendingRepositoriesService: TrendingRepositoriesService
    weak private var trendingRepositoriesDelegate: RepositoriesViewDelegate?
    var currentPage = 1
    init(trendingRepositoriesService: TrendingRepositoriesService) {
        self.trendingRepositoriesService = trendingRepositoriesService
    }

    func setViewDelegate(trendingRepositoriesDelegate: RepositoriesViewDelegate?) {
        self.trendingRepositoriesDelegate = trendingRepositoriesDelegate
    }

    func loadMoreRepositories(with interval: IntervalType) {
        trendingRepositoriesService.getTrendingRepositories(interval: interval, page: currentPage + 1) { [weak self] (items, hasError) in
            if items.count > 0 {
                self?.currentPage+=1
            }
            self?.trendingRepositoriesDelegate?.didLoadMoreRepositories(repositories: items, hasError: hasError)
        }
    }

    func showInitialRepositories(with interval: IntervalType) {
        currentPage = 1
        trendingRepositoriesService.getTrendingRepositories(interval: interval, page: currentPage) { [weak self] (items, hasError) in
            self?.trendingRepositoriesDelegate?.didLoadInitialRepositories(repositories: items, hasError: hasError)
        }
    }
}
