//
//  BaseInfoCollectionViewCell.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 25/09/2020.
//

import UIKit
import Kingfisher

protocol SetFavouriteDelegate: NSObjectProtocol {
    func didChangeFavourite(on cell: BaseInfoCollectionViewCell)
}

class BaseInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatarThumbnail: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    private var repoModel: RepositoriesModel.RepoItem?
    weak var favouriteDelegate: SetFavouriteDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.avatarThumbnail.layer.cornerRadius = self.avatarThumbnail.frame.size.height / 2
    }

    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        favouriteDelegate?.didChangeFavourite(on: self)

        guard let model = repoModel else { return }
        if let favorite = DatabaseManager.sharedInstance.getFavorite(with: model.id) {
            DatabaseManager.sharedInstance.deleteFromDb(object: favorite)
        } else {
            DatabaseManager.sharedInstance.addFavorite(repo: model)
        }
    }

    func setupWithModel(model: RepositoriesModel.RepoItem) {
        repoModel = model
        userNameLabel.text = "\(model.owner.login)/\(model.name)"
        descriptionLabel.text = model.description
        starsLabel.text = "\(model.stargazersCount)\(NSLocalizedString(" Stars", comment: ""))"
        if let avatarURL = model.owner.avatarUrl {
            avatarThumbnail.kf.setImage(with: URL.init(string: avatarURL))
        }
        favoriteButton.isSelected = DatabaseManager.sharedInstance.getFavorite(with: model.id) != nil
    }
}
