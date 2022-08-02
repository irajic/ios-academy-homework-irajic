//
//  ShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 7/25/22.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    func configure(with item: String) {
        titleLabel.text = "\(item)"
    }
}
