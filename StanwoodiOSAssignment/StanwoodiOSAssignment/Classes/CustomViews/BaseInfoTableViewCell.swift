//
//  BaseInfoTableViewCell.swift
//  StanwoodiOSAssignment
//
//  Created by Simu Voicu-Mircea on 23/09/2020.
//

import UIKit
import Kingfisher

class BaseInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarThumbnail: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarThumbnail.layer.cornerRadius = self.avatarThumbnail.frame.size.height / 2
    }

    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    func setupWithModel(model: RepositoriesModel.RepoItem) {
        userNameLabel.text = "\(model.owner.login)/\(model.name)"
        descriptionLabel.text = model.description
        if let avatarURL = model.owner.avatarUrl {
            avatarThumbnail.kf.setImage(with: URL.init(string: avatarURL))
        }
    }
}
