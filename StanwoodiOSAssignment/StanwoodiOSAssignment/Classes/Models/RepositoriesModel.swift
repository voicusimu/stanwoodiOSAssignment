//
//  RepositoriesModel.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 23/09/2020.
//

import Foundation

struct RepositoriesModel: Codable {
    let items: [RepoItem]

    struct RepoItem:Codable {
        let id: Int
        let name: String
        let description: String
        let owner: Owner
        let stargazersCount: Int
        let language: String
        let forks: Int
        let createdAt: String
        let htmlUrl: String

        private enum CodingKeys: String, CodingKey {
            case id,
                 name,
                 description,
                 owner,
                 stargazersCount = "stargazers_count",
                 language,
                 forks,
                 createdAt = "create_at",
                 htmlUrl = "html_url"
        }
        
        struct Owner: Codable {
            let login: String
            let avatarUrl: String

            private enum CodingKeys: String, CodingKey {
                case login,
                     avatarUrl = "avatar_url"
            }
        }
    }
}
