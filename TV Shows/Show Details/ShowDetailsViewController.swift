//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/26/22.
//

import UIKit
import MBProgressHUD
import Alamofire

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableViewDetails: UITableView!
    
    // MARK: - Public Properties
    
    var authInfo: AuthInfo? = nil
    var showID: String = ""
    var shows: Show?
    
    // MARK: - Private properties
    
    private var items: [Review] = []
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        guard let shows = shows else { return }
        //        self.title = String(describing: shows.title)
        title = shows?.title
        setUpTableView()
        getReviews()
    }
    
    private func getReviews() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/shows/\(showID)/reviews",
                method: .get,
                parameters: ["page": "1", "items": "5"],
                headers: HTTPHeaders(self.authInfo?.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] reviewResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch reviewResponse.result {
                case .success(let reviewsResponse):
                    self.items = reviewsResponse.reviews
                    self.tableViewDetails.reloadData()
                case .failure:
                    print("Reviews can not be added")
                }
            }
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 700
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell1 = tableViewDetails.dequeueReusableCell(
                withIdentifier: String(describing: ShowDetailsTableViewCell.self),
                for: indexPath
            ) as! ShowDetailsTableViewCell
            cell1.configureCell(with: shows)
            return cell1
        } else {
            let cell2 = tableViewDetails.dequeueReusableCell(
                withIdentifier: String(describing: ReviewDetailsTableViewCell.self),
                for: indexPath
            ) as! ReviewDetailsTableViewCell
            cell2.configureCell(with: items[indexPath.row])
            return cell2
        }
    }
}


extension ShowDetailsViewController {
    func setUpTableView() {
        tableViewDetails.rowHeight = UITableView.automaticDimension
        tableViewDetails.dataSource = self
        tableViewDetails.delegate = self
    }
}
