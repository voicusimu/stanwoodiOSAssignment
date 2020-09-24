//
//  RepoItemDBModel.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import Foundation
import RealmSwift

class RepoItemDBModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var repoDescription: String?
    @objc dynamic var stargazersCount: Int = 0
    @objc dynamic var language: String?
    @objc dynamic var forks: Int = 0
    @objc dynamic var createdAt: String = ""
    @objc dynamic var htmlUrl: String = ""
    @objc dynamic var login: String = ""
    @objc dynamic var avatarUrl: String?

    override static func primaryKey() -> String? {
          return "id"
    }

    convenience init(with repositoryModel: RepositoriesModel.RepoItem) {
        self.init()
        self.id = repositoryModel.id
        self.name = repositoryModel.name
        self.repoDescription = repositoryModel.description
        self.stargazersCount = repositoryModel.stargazersCount
        self.language = repositoryModel.language
        self.forks = repositoryModel.forks
        self.createdAt = repositoryModel.createdAt
        self.htmlUrl = repositoryModel.htmlUrl
        self.login = repositoryModel.owner.login
        self.avatarUrl = repositoryModel.owner.avatarUrl
    }
}
