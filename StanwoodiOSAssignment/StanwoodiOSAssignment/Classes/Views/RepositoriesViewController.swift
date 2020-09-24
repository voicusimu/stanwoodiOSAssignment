//
//  ViewController.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 23/09/2020.
//

import UIKit

enum StatusType {
    case Loading
    case NoData
    case HasData
}

class RepositoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!

    var repositories: [RepositoriesModel.RepoItem] = []

    private let repositoriesPresenter = RepositoriesPresenter(trendingRepositoriesService: TrendingRepositoriesService())

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        repositoriesPresenter.setViewDelegate(trendingRepositoriesDelegate: self)
        repositoriesPresenter.trendingRepositories(with: .LastDay, page: 1)
        setupStatus(status: .Loading)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        setupStatus(status: .Loading)
        switch sender.selectedSegmentIndex {
        case 0:
            repositoriesPresenter.trendingRepositories(with: .LastDay, page: 1)
        case 1:
            repositoriesPresenter.trendingRepositories(with: .LastWeek, page: 1)
        case 2:
            repositoriesPresenter.trendingRepositories(with: .LastMonth, page: 1)
        default:
            break
        }
    }

}

//MARK: Delegates

extension RepositoriesViewController: RepositoriesViewDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "baseInfoCell", for: indexPath) as? BaseInfoTableViewCell {
            cell.setupWithModel(model: repositories[indexPath.row])

            return cell
        }

        return UITableViewCell()
    }

    func displayTrendingRepositories(repositories: [RepositoriesModel.RepoItem]) {
        self.repositories = repositories
        setupStatus(status: repositories.count > 0 ? .HasData : .NoData)
        tableView.reloadData()
    }
}

    //MARK: Helpers
extension RepositoriesViewController {
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
