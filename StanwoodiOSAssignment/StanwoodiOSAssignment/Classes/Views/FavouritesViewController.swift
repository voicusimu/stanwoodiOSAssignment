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

    private let favouritesPresenter = FavouritesPresenter()
    var favouriteRepositories: [RepoItemDBModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesPresenter.setViewDelegate(favouritesRepositoriesDelegate: self)
        tableView.delegate = self
        tableView.dataSource = self
        setupStatus(status: .Loading)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesPresenter.getFavouritesRepositories()
    }
}

//MARK: Delegates

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource, FavouritesViewDelegate, FavouriteDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favouriteRepositories.count <= 0 {
            setupStatus(status: .NoData)
        }
        return favouriteRepositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "baseInfoCell", for: indexPath) as? BaseInfoTableViewCell {
            cell.setupWithModel(model: favouritesPresenter.repoModel(from: favouriteRepositories[indexPath.row]))
            cell.favouriteDelegate = self
            return cell
        }

        return UITableViewCell()
    }

    func displayFavouritesRepositories(repositories: [RepoItemDBModel]) {
        self.favouriteRepositories = repositories
        setupStatus(status: repositories.count > 0 ? .HasData : .NoData)
        tableView.reloadData()
    }

    func didChangeFavourite(on cell: BaseInfoTableViewCell) {
        guard let indexPathToRemove = tableView.indexPath(for: cell) else {
            return
        }
        favouriteRepositories.remove(at: indexPathToRemove.row)
        tableView.deleteRows(at: [indexPathToRemove], with: .automatic)
    }
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
            statusLabel.text = NSLocalizedString("No favourites yet", comment: "")
        case .HasData:
            activityIndicator.stopAnimating()
            statusLabel.isHidden = true
            tableView.isHidden = false
        }
    }
}
