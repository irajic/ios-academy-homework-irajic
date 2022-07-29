//
//  ShowDetailsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 7/26/22.
//

import UIKit

class ShowDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var reviewInfo: UILabel!
    @IBOutlet weak var ratingViewAvarage: RatingView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
        reviewInfo.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingViewAvarage.configure(withStyle: .small)
        ratingViewAvarage.isEnabled = false
    }
    
    // MARK: - Methodes
    func configureCell(with item: Show?) {
        guard let item = item else { return }
        descriptionLabel.text = item.description
        print("\(item.averageRating)")
        reviewInfo.text = "\(item.numberOfReviews) reviews, \(String(describing: item.averageRating)) avarage"
        let rating = item.averageRating
        guard let rating = rating else { return }
        ratingViewAvarage.setRoundedRating(rating)
    }
}
