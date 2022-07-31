//
//  ShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 7/25/22.
//

import UIKit
import Kingfisher

class ShowTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var showImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    func configure(with item: Show?) {
        guard let title = item?.title else { return }
        titleLabel.text = "\(title)"
        showImage.kf.setImage(
            with: item?.imageUrl,
            placeholder: UIImage(named:"ic-show-placeholder-vertical")
        )
    }
}
