//
//  ProfileViewController.swift
//  TV Shows
//
//  Created by Infinum on 8/1/22.
//

import UIKit
import MBProgressHUD
import Kingfisher
import Alamofire

final class ProfileViewController: UIViewController {
    
    // MARK: - Public properties
    
    var authInfo: AuthInfo? = nil
    let imagePicker = UIImagePickerController()
    
    // MARK: - Private properties
    
    let NotificationLogoutRequested = "NotificationLogoutRequested"
    
    // MARK: - Outlets
    
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var profilePhoto: UIImageView!
    
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCloseButton()
        fetchUserInfo()
        
        imagePicker.delegate = self
    }
    
    // MARK: - Methodes
    func addCloseButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    @objc func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logputButtonActionHandler(_ sender: UIButton) {
        dismiss(animated: true, completion:  {
            UserDefaults.standard.removeObject(forKey: "authInfo")
            let notification = Notification(
                name: Notification.Name(rawValue: "NotificationLogoutRequested"),
                object: nil,
                userInfo: [:]
            )
            NotificationCenter.default.post(notification)
        })
    }
}

private extension ProfileViewController {
    private func fetchUserInfo() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users/me",
                method: .get,
                headers: HTTPHeaders(self.authInfo?.headers ?? [:])
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let userResponse):
                    self.userEmailLabel.text = userResponse.user.email
                    self.profilePhoto.kf.setImage(
                        with: userResponse.user.imageUrl,
                        placeholder: UIImage(named: "ic-profile-placeholder")
                    )
                case .failure:
                    print("User info can't be feched")
                }
            }
    }
    
    private func storeImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
        let requestData = MultipartFormData()
        requestData.append(
            imageData,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
        
        AF
            .upload(
                multipartFormData: requestData,
                to: "https://tv-shows.infinum.academy/users",
                method: .put,
                headers: HTTPHeaders(self.authInfo?.headers ?? [:])
            )
            .validate(statusCode: 200..<422)
            .responseDecodable(of: UserResponse.self) {[weak self] dataResponse in
                guard let self = self else { return }
                print("\(dataResponse.self)")
                switch dataResponse.result {
                case .success(let userResponse):
                    self.profilePhoto.kf.setImage(
                        with: userResponse.user.imageUrl,
                        placeholder: UIImage(named: "ic-profile-placeholder")
                    )
                case .failure:
                    print("Image is not stored.")
                }
            }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    func didLogout(_ navigationController: UINavigationController) -> Bool {
        navigationController.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePhoto.contentMode = .scaleAspectFit
            profilePhoto.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        guard let image = profilePhoto.image else { return }
        storeImage(image)
    }
}
