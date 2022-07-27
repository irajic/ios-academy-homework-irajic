//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/26/22.
//

import UIKit

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableViewDetails: UITableView!
    
    // MARK: - Public Properties
    
    var authInfo: AuthInfo? = nil
    var showID: String = ""
    var shows: Show?
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let shows = shows else { return }
        self.title = String(describing: shows.title)
        setUpTableView()
    }
    
}

extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ShowDetailsTableViewCell.self),
            for: indexPath
        ) as! ShowDetailsTableViewCell
        let showInfo = shows?.description
        let scoreInfo = shows?.averageRating
        let reviews = shows!.numberOfReviews
        cell.configureDescriotion(with: showInfo)
        cell.configureReviewInfo(with: reviews, avarage: scoreInfo)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewDetails.deselectRow(at: indexPath, animated: true)
    }
}

private extension ShowDetailsViewController {
    func setUpTableView() {
        tableViewDetails.rowHeight = UITableView.automaticDimension
        tableViewDetails.delegate = self
        tableViewDetails.dataSource = self
    }
}
