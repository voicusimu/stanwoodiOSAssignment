//
//  DetailsViewController.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 24/09/2020.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var openInGithubButton: UIButton!
    var detailsPresenter: DetailsPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        openInGithubButton.layer.cornerRadius = 5
        guard let presenter = detailsPresenter else {
            return
        }
        detailsPresenter?.setViewDelegate(detailsViewDelegate: self)
        presenter.showDetails()
    }

    @IBAction func didTapOpenInGuthubButton(_ sender: UIButton) {
        detailsPresenter?.openGitHubPage()
    }
}

extension DetailsViewController: DetailsViewDelegate {
    func showDetails(for model: RepositoriesModel.RepoItem) {
        let inputDateFormatter = DateFormatter.init()
        inputDateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        let outputDateFormatter = DateFormatter.init()
        outputDateFormatter.dateFormat = "dd/MM/YYYY"
        let createdDate = inputDateFormatter.date(from: model.createdAt)
        var createdString = NSLocalizedString("No info", comment: "")
        if let date = createdDate {
            createdString = outputDateFormatter.string(from: date)
        }
        self.title = model.owner.login
        descriptionLabel.text = model.description
        languageLabel.text = model.language != nil ? model.language : NSLocalizedString("No info", comment: "")
        forksLabel.text = "\(model.forks)\(NSLocalizedString(" Forks", comment: ""))"
        starsLabel.text = "\(model.stargazersCount)\(NSLocalizedString(" Stars", comment: ""))"
        createdLabel.text = "\(NSLocalizedString("Created at: ", comment: ""))\(createdString)"
    }

    func openGitHubPage(for model: RepositoriesModel.RepoItem) {
        guard let url = URL.init(string: model.htmlUrl) else {
            return
        }
        UIApplication.shared.open(url)
    }
}
