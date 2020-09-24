//
//  FavouritesPresenter.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import Foundation
import RealmSwift

protocol FavouritesViewDelegate: NSObjectProtocol {
    func displayFavouritesRepositories(repositories: [RepoItemDBModel])
}

class FavouritesPresenter {
    weak private var favouritesRepositoriesDelegate: FavouritesViewDelegate?

    func setViewDelegate(favouritesRepositoriesDelegate: FavouritesViewDelegate?) {
        self.favouritesRepositoriesDelegate = favouritesRepositoriesDelegate
    }

    func getFavouritesRepositories() {
        let favouritesRepositories = Array.init(DatabaseManager.sharedInstance.getAllFavoritesFromDB()) 
        favouritesRepositoriesDelegate?.displayFavouritesRepositories(repositories: favouritesRepositories)
    }

    func repoModel(from repoDBModel: RepoItemDBModel) -> RepositoriesModel.RepoItem {
        return RepositoriesModel.RepoItem.init(id: repoDBModel.id,
                                               name: repoDBModel.name,
                                               description: repoDBModel.repoDescription,
                                               owner: RepositoriesModel.RepoItem.Owner.init(login: repoDBModel.login, avatarUrl: repoDBModel.avatarUrl),
                                               stargazersCount: repoDBModel.stargazersCount,
                                               language: repoDBModel.language,
                                               forks: repoDBModel.forks,
                                               createdAt: repoDBModel.createdAt,
                                               htmlUrl: repoDBModel.htmlUrl)
    }
}
