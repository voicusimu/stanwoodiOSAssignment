//
//  TrendingRepositoriesService.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 23/09/2020.
//

import Foundation
import Alamofire

enum IntervalType {
    case LastMonth
    case LastWeek
    case LastDay
}

class TrendingRepositoriesService {
    func getTrendingRepositories(date: Date = Date.init(),
                                 interval: IntervalType = .LastDay,
                                 ascending: Bool? = false,
                                 page: Int? = 1,
                                 callBack: @escaping ([RepositoriesModel.RepoItem]) -> Void) {

        let headers: HTTPHeaders = [.accept("application/json")]

        let order = ascending ?? false ? "asc" : "desc"
        let date = dateParameter(date: date, interval: interval)

        let parameters = ["q": "created:>\(date)",
                          "sort": "stars",
                          "order": "\(order)",
                          "page": "\(page ?? 1)"]

        AF.request("https://api.github.com/search/repositories",
                   parameters: parameters,
                   headers: headers).response { response in
                    guard let data = response.data else {
                        callBack([])
                        return
                    }
                    debugPrint(response)
                    do {
                        let responseModel = try JSONDecoder().decode(RepositoriesModel.self, from: data)
                        callBack(responseModel.items)
                    } catch(_) {
                        callBack([])
                    }
                   }
    }

    //MARK: Helpers

    private func dateParameter(date: Date, interval: IntervalType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        switch interval {
        case .LastDay:
            let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: date)
            return dateFormatter.string(from: oneDayAgo ?? Date())
        case .LastWeek:
            let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: date)
            return dateFormatter.string(from: oneWeekAgo ?? Date())
        case .LastMonth:
            let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: date)
            return dateFormatter.string(from: oneMonthAgo ?? Date())
        }
    }
}
