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
    
    func configureCell(with item: Review) {
        userEmailLabel.text = "\(item.user.email)"
        reviewLabel.text = "\(item.comment)"
    }
    
}
