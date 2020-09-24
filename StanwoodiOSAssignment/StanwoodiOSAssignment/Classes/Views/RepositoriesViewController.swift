//
//  ViewController.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 23/09/2020.
//

import UIKit
import Alamofire

enum StatusType {
    case Loading
    case NoData
    case HasData
    case LoadingMore
    case Error
}

class RepositoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var segmentedControlTopConstraint: NSLayoutConstraint!

    private let repositoriesPresenter = RepositoriesPresenter(trendingRepositoriesService: TrendingRepositoriesService())
    var repositories: [RepositoriesModel.RepoItem] = []
    var filteredRepositories: [RepositoriesModel.RepoItem] = []
    var status: StatusType = .Loading
    var selectedIntervalType: IntervalType = .LastDay
    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    var isInternetAvailable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        repositoriesPresenter.setViewDelegate(trendingRepositoriesDelegate: self)
        setupStatus(status: .Loading)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        if !isInternetAvailable {
            setupStatus(status: .NoData)
            presentOKAlert(title: "No connection", message: NSLocalizedString("No internet connection available", comment: ""))
        } else {
            repositoriesPresenter.showInitialRepositories(with: .LastDay)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        searchController.isActive = false
        if !isInternetAvailable {
            setupStatus(status: .NoData)
            presentOKAlert(title: "No connection", message: NSLocalizedString("No internet connection available", comment: ""))
            return
        }
        setupStatus(status: .Loading)

        switch sender.selectedSegmentIndex {
        case 0:
            selectedIntervalType = .LastDay
            repositoriesPresenter.showInitialRepositories(with: .LastDay)
        case 1:
            repositoriesPresenter.showInitialRepositories(with: .LastWeek)
            selectedIntervalType = .LastWeek
        case 2:
            repositoriesPresenter.showInitialRepositories(with: .LastMonth)
            selectedIntervalType = .LastMonth
        default:
            break
        }
    }
}

//MARK: Delegates

extension RepositoriesViewController: RepositoriesViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var datasource: [RepositoriesModel.RepoItem]
        if isFiltering {
            datasource = filteredRepositories
        } else {
            datasource = repositories
        }
        if datasource.count <= 0 {
            setupStatus(status: .NoData)
        }
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "baseInfoCell", for: indexPath) as? BaseInfoTableViewCell {
            let repoModel: RepositoriesModel.RepoItem
            if isFiltering {
                repoModel = filteredRepositories[indexPath.row]
            } else {
                repoModel = repositories[indexPath.row]
            }
            cell.setupWithModel(model: repoModel)
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard repositories.count > 10 else {
            return
        }
        let lastElement = repositories.count - 10
        if  (indexPath.row == lastElement && status != .LoadingMore && !isFiltering) {
            setupStatus(status: .LoadingMore)
            repositoriesPresenter.loadMoreRepositories(with: selectedIntervalType)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsPresenter = DetailsPresenter.init(trendingRepositoryModel: repositories[indexPath.row])
        self.performSegue(withIdentifier: "showDetails", sender: detailsPresenter)
    }

    func didLoadInitialRepositories(repositories: [RepositoriesModel.RepoItem], hasError: Bool) {
        self.repositories = repositories
        if hasError {
            setupStatus(status: .Error)
        } else {
            setupStatus(status: repositories.count > 0 ? .HasData : .NoData)
        }
        tableView.reloadData()
    }

    func didLoadMoreRepositories(repositories: [RepositoriesModel.RepoItem], hasError: Bool) {
        if hasError {
            setupStatus(status: .Error)
        } else {
            self.repositories.append(contentsOf: repositories)
            setupStatus(status: .HasData)
            tableView.reloadData()
        }
        tableView.hideLoadingMoreIndicator()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height - 1) &&
                status != .LoadingMore &&
                !isFiltering) {
            setupStatus(status: .LoadingMore)
            repositoriesPresenter.loadMoreRepositories(with: selectedIntervalType)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView.contentOffset.y <= 0 {
            self.segmentedControlTopConstraint.constant = 40 - self.tableView.contentOffset.y
        } else {
            self.segmentedControlTopConstraint.constant = 40
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let presenter = sender as? DetailsPresenter,
              let detailsViewController = segue.destination as? DetailsViewController else {
            return
        }
        detailsViewController.detailsPresenter = presenter
    }
}

extension RepositoriesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else {
        return
    }
    filterContentForSearchText(searchText)
  }
}

    //MARK: Helpers
extension RepositoriesViewController {
    func setupStatus(status: StatusType) {
        self.status = status
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
        case .LoadingMore:
            tableView.showLoadingMoreIndicator(IndexPath(row: repositories.count, section: 0), closure: {})
            statusLabel.isHidden = true
            tableView.isHidden = false
        case .Error:
            presentOKAlert(title: "Error", message: NSLocalizedString("An error has occured.\nProbably unauthenticated request limit reached", comment: ""))
            activityIndicator.stopAnimating()
            statusLabel.isHidden = true
            tableView.isHidden = false
            break
        }
    }

    func presentOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) {_ in }
        alert.addAction(dismissAction)
        self.present(alert, animated: true)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredRepositories = repositories.filter { (repo: RepositoriesModel.RepoItem) -> Bool in
            return (repo.name.lowercased().contains(searchText.lowercased()) ||
                    repo.owner.login.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
}
