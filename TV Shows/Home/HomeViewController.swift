//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/20/22.
//

import UIKit
import MBProgressHUD
import Alamofire

final class HomeViewController: UIViewController {
    
    // MARK: - Public properties
    
    var authInfo: AuthInfo? = nil
    
    // MARK: - Private properties
    
    private var items: [Show] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.title = "Shows"
        self.navigationItem.setHidesBackButton(true, animated: false)
        getShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

private extension HomeViewController {
    
    private func getShows() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/shows",
                method: .get,
                parameters: ["page": "1", "items": "100"],
                headers: HTTPHeaders(self.authInfo?.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let showsResponse):
                    print("\(showsResponse.shows)")
                    self.items = showsResponse.shows
                    self.tableView.reloadData()
                case .failure:
                    print("Shows can not be added")
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print("selected item: \(item)")
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
