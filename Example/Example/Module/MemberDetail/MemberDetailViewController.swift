//
//  MemberDetailViewController.swift
//  BDS
//
//  Created by INVISION on 11/11/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit

class MemberDetailViewController: UIViewController, StoryboardLoadable {
    var presenter: MemberDetailPresenterInterface?

    @IBOutlet weak var memberDetailView: UIView!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var memberIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    
    @IBOutlet weak var healthDetailView: UIView!
    @IBOutlet weak var deleteMemberView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupNavigationBarItems()
        renderDetail()
    }
    
    @IBAction func goPersonalButton(_ sender: Any) {
        presenter?.goToProfileDetail()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        presenter?.willDeleteMember()
    }
    
    
    func setupUI() {
        // MARK: memberDetailView style
        memberDetailView.setCornerRadius(26, borderWidth: 0, borderColor: .apBlue)
        memberDetailView.layer.shadowColor = UIColor.apGray.cgColor
        memberDetailView.layer.shadowOpacity = 0.8
        memberDetailView.layer.shadowOffset = .zero
        memberDetailView.layer.shadowRadius = 3
        //        memberDetailView.layer.shadowPath = UIBezierPath(rect: memberDetailView.bounds).cgPath
        memberDetailView.layer.shouldRasterize = true
        memberDetailView.layer.rasterizationScale = UIScreen.main.scale
        memberDetailView.layer.masksToBounds = false
        
        // MARK: healthDetailView style
        healthDetailView.setCornerRadius(26, borderWidth: 0, borderColor: .apBlue)
        healthDetailView.layer.shadowColor = UIColor.apGray.cgColor
        healthDetailView.layer.shadowOpacity = 0.8
        healthDetailView.layer.shadowOffset = .zero
        healthDetailView.layer.shadowRadius = 3
        //        healthDetailView.layer.shadowPath = UIBezierPath(rect: healthDetailView.bounds).cgPath
        healthDetailView.layer.shouldRasterize = true
        healthDetailView.layer.rasterizationScale = UIScreen.main.scale
        healthDetailView.layer.masksToBounds = false
        
        // MARK: healthDetailView style
        deleteMemberView.setCornerRadius(26, borderWidth: 0, borderColor: .apBlue)
        deleteMemberView.layer.shadowColor = UIColor.apGray.cgColor
        deleteMemberView.layer.shadowOpacity = 0.8
        deleteMemberView.layer.shadowOffset = .zero
        deleteMemberView.layer.shadowRadius = 3
        //        healthDetailView.layer.shadowPath = UIBezierPath(rect: healthDetailView.bounds).cgPath
        deleteMemberView.layer.shouldRasterize = true
        deleteMemberView.layer.rasterizationScale = UIScreen.main.scale
        deleteMemberView.layer.masksToBounds = false
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "สมาชิกร่วม"
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Prompt-Medium", size: 17)!,
            .foregroundColor: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes

        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bar_bg")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupNavigationBarItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func renderDetail() {
        let user = presenter?.userData
        let url = user?.profileImage ?? ""
        uploadImage.kf.setImage(with: URL(string: url)) { result in
            switch result {
            case let .success(value):
                print(value.image)
                print(value.cacheType)
                print(value.source)
                self.uploadImage.layer.borderWidth = 1
                self.uploadImage.layer.masksToBounds = false
                self.uploadImage.layer.borderColor = UIColor.white.cgColor
                self.uploadImage.layer.cornerRadius = self.uploadImage.frame.height / 2
                self.uploadImage.clipsToBounds = true

            case let .failure(error):
                print(error)
            }
        }
        memberIdLabel.text = user?.memberId ?? "-"
        nameLabel.text = user?.name ?? "-"
        genderLabel.text = user?.sex ?? "-"
        ageLabel.text = user?.age ?? "-"
        relationLabel.text = user?.relationship ?? "-"
    }
}

extension MemberDetailViewController: MemberDetailViewInterface {
}
