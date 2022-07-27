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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
        reviewInfo.text = ""
    }
    
    // MARK: - Methodes
    func configureCell(with item: Show?) {
        guard let item = item else { return }
        descriptionLabel.text = item.description
        reviewInfo.text = "\(item.numberOfReviews) reviews, \(String(describing: item.averageRating)) avarage"
    }
}
