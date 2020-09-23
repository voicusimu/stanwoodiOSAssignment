//
//  ViewController.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 23/09/2020.
//

import UIKit

class RepositoriesViewController: UIViewController {
    private let repositoriesPresenter = RepositoriesPresenter(trendingRepositoriesService: TrendingRepositoriesService())

    override func viewDidLoad() {
        super.viewDidLoad()
        repositoriesPresenter.setViewDelegate(trendingRepositoriesDelegate: self)
        // Do any additional setup after loading the view.
    }
}

extension RepositoriesViewController: RepositoriesViewDelegate {
    func displayTrendingRepositories(repositories: [RepositoriesModel.RepoItem]) {
        
    }
}
