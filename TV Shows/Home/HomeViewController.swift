//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/20/22.
//

import UIKit
import SwiftUI
import MBProgressHUD
import Alamofire
import Kingfisher

final class HomeViewController: UIViewController {
    
    // MARK: - Public properties
    
    var authInfo: AuthInfo? = nil
    var notificationToken: NSObjectProtocol?
    
    // MARK: - Private properties
    
    private var items: [Show] = []
    private var currentPage: Int = 1
    private var itemsPerPage: Int = 20
    private var numberOfItems: Int = 0
    private var numberOfPages: Int = 0
    private var isLoadingShows = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.title = "Shows"
        self.navigationItem.setHidesBackButton(true, animated: false)
        getShows()
        
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler)
        )
        profileDetailsItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = profileDetailsItem
        notify()
    }
    deinit {
        NotificationCenter.default.removeObserver(notificationToken!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Methodes
    
    @objc
    private func profileDetailsActionHandler() {
        let profileStoryboard = UIStoryboard(name: "ProfileDetails", bundle: nil)
        let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        
        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.modalPresentationStyle = .fullScreen
        profileViewController.authInfo = authInfo
        present(navigationController, animated: true)
    }
    
    private func notify() {
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        notificationToken = NotificationCenter
            .default
            .addObserver(
                forName: Notification.Name(rawValue: "NotificationLogoutRequested"),
                object: nil,
                queue: nil,
                using: { [weak self] notification in
                    guard let self = self else { return }
                    self.navigationController?.setViewControllers([loginViewController], animated: true)
                })
    }
}

private extension HomeViewController {
    
    private func getShows() {
        MBProgressHUD.showAdded(to: view, animated: true)
        isLoadingShows = true
        
        AF
            .request(
                "https://tv-shows.infinum.academy/shows",
                method: .get,
                parameters: ["page": currentPage, "items": itemsPerPage],
                headers: HTTPHeaders(self.authInfo?.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let showsResponse):
                    self.items.append(contentsOf: showsResponse.shows)
                    self.numberOfItems = showsResponse.meta.pagination.count
                    self.numberOfPages = showsResponse.meta.pagination.pages
                    self.tableView.reloadData()
                    self.isLoadingShows = true
                case .failure:
                    print("Shows can not be added")
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.isLoadingShows = false
            }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ShowTableViewCell.self),
            for: indexPath
        ) as! ShowTableViewCell
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == items.count - 1  else {
            return
        }
            if
                numberOfItems > items.count,
                !isLoadingShows
        
        {
                currentPage = currentPage + 1
                getShows()
                tableView.reloadData()
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let showDetailsStoryboard = UIStoryboard(name: "ShowDetails", bundle: .main)
        let showDetailsViewController = showDetailsStoryboard.instantiateViewController(withIdentifier: "ShowDetails") as! ShowDetailsViewController
        showDetailsViewController.authInfo = authInfo
        showDetailsViewController.showID = items[indexPath.row].id
        showDetailsViewController.shows = items[indexPath.row]
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
}

private extension HomeViewController {
    func setUpTableView () {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}


