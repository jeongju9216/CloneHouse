//
//  LaunchViewController.swift
//  CloneZip
//
//  Created by 유정주 on 2023/06/02.
//

import UIKit

final class LaunchViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCloneListVC()
    }
    
    private func showCloneListVC() {
        if let cloneListVC = CloneListViewController.instantiate as? CloneListViewController {
            let nav = UINavigationController(rootViewController: cloneListVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}
