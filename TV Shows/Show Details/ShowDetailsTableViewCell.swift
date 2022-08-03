//
//  ShowDetailsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 7/26/22.
//

import UIKit
import Kingfisher

class ShowDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var reviewInfo: UILabel!
    @IBOutlet weak var ratingViewAvarage: RatingView!
    @IBOutlet private weak var showImageBig: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
        reviewInfo.text = ""
        ratingViewAvarage.setRoundedRating(0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingViewAvarage.configure(withStyle: .small)
        ratingViewAvarage.isEnabled = false
    }
    
    // MARK: - Methodes
    func configureCell(with item: Show?) {
        if item?.numberOfReviews != 0 {
            showImageBig.kf.setImage(
                with: item?.imageUrl,
                placeholder: UIImage(named: "ic-show-placeholder-vertical")
            )
            guard let item = item else { return }
            descriptionLabel.text = item.description
            let rating = item.averageRating
            guard let rating = rating else { return }
            ratingViewAvarage.setRoundedRating(rating)
            reviewInfo.text = "\(item.numberOfReviews) reviews, \(String(describing: rating)) avarage"
        } else {
            showImageBig.kf.setImage(
                with: item?.imageUrl,
                placeholder: UIImage(named: "ic-show-placeholder-vertical")
            )
            guard let item = item else { return }
            descriptionLabel.text = item.description
            reviewInfo.center.x = self.center.x
            reviewInfo.text = "No reviews yet"
            reviewInfo.textAlignment = .center
            ratingViewAvarage.isHidden = true
        }
    }
}
