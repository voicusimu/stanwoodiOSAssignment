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
    var filteredFavouriteRepositories: [RepoItemDBModel] = []
    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesPresenter.setViewDelegate(favouritesRepositoriesDelegate: self)
        tableView.delegate = self
        tableView.dataSource = self
        setupStatus(status: .Loading)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Favourites"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesPresenter.getFavouritesRepositories()
    }
}

//MARK: Delegates

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource, FavouritesViewDelegate, FavouriteDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var datasource: [RepoItemDBModel]
        if isFiltering {
            datasource = filteredFavouriteRepositories
        } else {
            datasource = favouriteRepositories
        }

        datasource.count <= 0 ? setupStatus(status: .NoData) : setupStatus(status: .HasData)
        
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "baseInfoCell", for: indexPath) as? BaseInfoTableViewCell {
            var repoModel: RepositoriesModel.RepoItem
            if isFiltering {
                repoModel = favouritesPresenter.repoModel(from: filteredFavouriteRepositories[indexPath.row])
            } else {
                repoModel = favouritesPresenter.repoModel(from: favouriteRepositories[indexPath.row])
            }
            cell.setupWithModel(model: repoModel)
            cell.favouriteDelegate = self
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryModel = favouritesPresenter.repoModel(from: favouriteRepositories[indexPath.row])
        let detailsPresenter = DetailsPresenter.init(trendingRepositoryModel: repositoryModel)
        self.performSegue(withIdentifier: "showDetails", sender: detailsPresenter)
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
        if isFiltering {
            let repoModel = filteredFavouriteRepositories[indexPathToRemove.row]
            if let indexToRemove = favouriteRepositories.firstIndex(of: repoModel) {
                favouriteRepositories.remove(at: indexToRemove)
            }
            filteredFavouriteRepositories.remove(at: indexPathToRemove.row)
        } else {
            favouriteRepositories.remove(at: indexPathToRemove.row)
        }

        tableView.deleteRows(at: [indexPathToRemove], with: .automatic)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let presenter = sender as? DetailsPresenter,
              let detailsViewController = segue.destination as? DetailsViewController else {
            return
        }
        detailsViewController.detailsPresenter = presenter
    }
}

extension FavouritesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else {
        return
    }
    filterContentForSearchText(searchText)
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
        default:
            break
        }
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredFavouriteRepositories = favouriteRepositories.filter { (repo: RepoItemDBModel) -> Bool in
            return (repo.name.lowercased().contains(searchText.lowercased()) ||
                    repo.login.lowercased().contains(searchText.lowercased()))
      }

      tableView.reloadData()
    }
}
