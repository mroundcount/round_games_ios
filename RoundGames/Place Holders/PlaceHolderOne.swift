//
//  PlaceHolderOne.swift
//  RoundGames
//
//  Created by Michael Roundcount on 3/24/24.
//

import UIKit
import Foundation

class PlaceHolderOneViewController: UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.setTitle("Log Out", for: UIControl.State.normal)
    }
    
    @IBAction func logoutBtnDidTap(_ sender: Any) {
        print("Log Out Button Tapped")
        Api.User.logOut()
        navigateToHome()
    }
    
    func navigateToHome() {
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            scene.configureInitialViewController()
        }
    }
    
}


