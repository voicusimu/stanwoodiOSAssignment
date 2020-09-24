//
//  FavouritesViewController.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import UIKit

class FavouritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!

    var favouriteRepositories: [RepositoriesModel.RepoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupStatus(status: .Loading)
    }
}

//MARK: Delegates

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteRepositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "baseInfoCell", for: indexPath) as? BaseInfoTableViewCell {
            cell.setupWithModel(model: favouriteRepositories[indexPath.row])

            return cell
        }

        return UITableViewCell()
    }

//    func displayTrendingRepositories(repositories: [RepositoriesModel.RepoItem]) {
//        self.repositories = repositories
//        setupStatus(status: repositories.count > 0 ? .HasData : .NoData)
//        tableView.reloadData()
//    }
}

//MARK: Helpers
extension FavouritesViewController {
func setupStatus(status: StatusType) {
    switch status {
    case .Loading:
        activityIndicator.startAnimating()
        statusLabel.isHidden = false
        tableView.isHidden = true
        statusLabel.text = NSLocalizedString("Loading...", comment: "")
    case .NoData:
        activityIndicator.stopAnimating()
        statusLabel.isHidden = false
        tableView.isHidden = true
        statusLabel.text = NSLocalizedString("No data", comment: "")
    case .HasData:
        activityIndicator.stopAnimating()
        statusLabel.isHidden = true
        tableView.isHidden = false
    }
}
}
