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
    private var currentPage: Int = 1
    private var itemsPerPage: Int = 5
    private var numberOfItems: Int = 0
    private var numberOfPages: Int = 0
    private var isLoadingReviews = false
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = shows?.title
        setUpTableView()
        getReviews()
        
        tableViewDetails.refreshControl = UIRefreshControl()
        tableViewDetails.refreshControl?.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let writeReviewViewController = segue.destination as! WriteReviewViewController
        writeReviewViewController.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func writeAReview(_ sender: Any) {
        let writeReviewStoryboard = UIStoryboard(name: "WriteReview", bundle: .main)
        let writeReviewViewController = writeReviewStoryboard.instantiateViewController(withIdentifier: "WriteReview") as! WriteReviewViewController
        
        let navigationController = UINavigationController(rootViewController: writeReviewViewController)
        navigationController.modalPresentationStyle = .fullScreen
        writeReviewViewController.showID = Int(showID)!
        writeReviewViewController.authInfo = authInfo
        present(navigationController, animated: true)
    }
    
    // MARK: - Methodes
    
    @objc private func didPullToRefresh() {
        items.removeAll()
        currentPage = 1
        getReviews()
    }
    
    private func getReviews() {
        MBProgressHUD.showAdded(to: view, animated: true)
        self.isLoadingReviews = true
        
        AF
            .request(
                "https://tv-shows.infinum.academy/shows/\(showID)/reviews",
                method: .get,
                parameters: ["page": currentPage, "items": itemsPerPage],
                headers: HTTPHeaders(self.authInfo?.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] reviewResponse in
                guard let self = self else { return }
                switch reviewResponse.result {
                case .success(let reviewsResponse):
                    self.items.append(contentsOf: reviewsResponse.reviews)
                    self.numberOfItems = reviewsResponse.meta.pagination.count
                    self.numberOfPages = reviewsResponse.meta.pagination.pages
                    DispatchQueue.main.async {
                        self.tableViewDetails.refreshControl?.endRefreshing()
                        self.tableViewDetails.reloadData()
                    }
                case .failure:
                    print("Reviews can not be added")
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.isLoadingReviews = false
            }
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 650
        } else {
            tableViewDetails.estimatedRowHeight = 150
            tableViewDetails.rowHeight = UITableView.automaticDimension
            return tableViewDetails.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == items.count - 1  else {
            return
        }
            if
                numberOfItems > items.count,
                !isLoadingReviews
        
        {
                currentPage = currentPage + 1
                getReviews()
                tableView.reloadData()
            }
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
        if shows?.numberOfReviews != 0 {
           let cell = numberOfReviewsNotZero(indexPath: indexPath)
            return cell
        } else {
            let cell = numberOfReviewsZero(indexPath: indexPath)
            return cell
        }
    }
}


extension ShowDetailsViewController {
    func setUpTableView() {
        tableViewDetails.estimatedRowHeight = 650
        tableViewDetails.rowHeight = UITableView.automaticDimension
        tableViewDetails.dataSource = self
        tableViewDetails.delegate = self
    }
    
    private func numberOfReviewsNotZero(indexPath: IndexPath) -> UITableViewCell {
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
    
private func numberOfReviewsZero(indexPath: IndexPath) -> UITableViewCell {
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
            cell2.isHidden = true
            numberOfItems = 0
            numberOfPages = 0
            return cell2
        }
    }
}

extension ShowDetailsViewController: WriteReviewControllerDelegate {
    func didAddNewReview(_ review: NewReview) {
        tableViewDetails.reloadData()
    }
}

