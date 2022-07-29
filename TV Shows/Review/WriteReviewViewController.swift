//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/27/22.
//

import UIKit
import MBProgressHUD
import Alamofire

protocol WriteReviewControllerDelegate: AnyObject {
    func newReview(_ review: [Review])
}

class WriteReviewViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var commentTF: UITextField!
    @IBOutlet weak var ratingViewSelect: RatingView!
    
    
    // MARK: - Public properties
    
    var authInfo: AuthInfo? = nil
    var showID: Int = 0
    var shows: Show?
    weak var delegate: WriteReviewControllerDelegate?
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseButton()
        
        ratingViewSelect.configure(withStyle: .large)
        ratingViewSelect.isEnabled = true
    }
    
    // MARK: - Methodes
    
    func addCloseButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    
   @IBAction func submitReview(_ sender: UIButton) {
        guard
            let comment = commentTF.text,
            !comment.isEmpty
        else {
            return
        }
       saveComment(rating: ratingViewSelect.rating, comment: comment, showId: showID, authInf: authInfo)
    }
}

private extension WriteReviewViewController {
    private func saveComment(rating: Int, comment: String, showId: Int, authInf: AuthInfo?) {
        let reviewParameters = [
            "rating": rating,
            "comment": comment,
            "show_id": showId
        ] as [String : Any]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/reviews",
                method: .post,
                parameters: reviewParameters,
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(self.authInfo?.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success (let reviewResponse):
                    self.delegate?.newReview(reviewResponse.reviews)
                    self.dismiss(animated: true, completion: nil)
                case .failure:
                    self.handleFaliure()
                }
            }
    }
    
    private func handleFaliure() {
        let alertController = UIAlertController(title: nil, message: "Cat't submit review", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension WriteReviewViewController: UITableViewDelegate {
    func submit(_ button: UIButton) -> Bool {
        button.resignFirstResponder()
        return true
    }
}


