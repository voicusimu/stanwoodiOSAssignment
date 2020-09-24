//
//  DatabaseManager.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import Foundation
import RealmSwift

public final class DatabaseManager {
    static let sharedInstance = DatabaseManager()
    private var database: Realm

    private init() {
        database = try! Realm()
    }

    func getAllFavoritesFromDB() -> Results<RepoItemDBModel> {
          let results: Results<RepoItemDBModel> = database.objects(RepoItemDBModel.self)
          return results
     }

    func getFavorite(with id: Int) -> RepoItemDBModel? {
        return database.object(ofType: RepoItemDBModel.self, forPrimaryKey: id)
    }

    func addFavorite(repo: RepositoriesModel.RepoItem) {
        let favoriteModel = RepoItemDBModel.init(with: repo)
          try! database.write {
            database.add(favoriteModel, update: .modified)
          }
     }

    func deleteAllFromDatabase() {
        try! database.write {
            database.deleteAll()
        }
    }

    func deleteFromDb(object: RepoItemDBModel) {
        try! database.write {
            database.delete(object)
        }
    }
}
