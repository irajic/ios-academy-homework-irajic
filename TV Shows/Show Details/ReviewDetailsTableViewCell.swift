//
//  ReviewDetailsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 7/27/22.
//

import UIKit

class ReviewDetailsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userEmailLabel.text = ""
        reviewLabel.text = ""
    }
    
    // MARK: - Methodes
    
    func configureUserEmail(with item: String) {
        userEmailLabel.text = "\(item)"
    }
    
    func configureReviewInfo(with review: String) {
        reviewLabel.text = review
    }
    
}
