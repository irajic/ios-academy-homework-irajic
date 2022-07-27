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
    
    func configureDescriotion(with item: String?) {
        guard let item = item else { return }
        descriptionLabel.text = "\(item)"
    }
    
    func configureReviewInfo(with numberOfReviews: Int, avarage: Double?) {
        guard let avarage = avarage else { return }
        reviewInfo.text = "\(numberOfReviews) reviews, \(avarage) avarage"
    }
    
}
