//
//  SplashViewController.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 6.04.2023.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet var splashLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let storedIsOpen = UserDefaults.standard.object(forKey: "isOpen")

        if storedIsOpen is String {
            splashLabel.text = "Hello!"
        } else {
            splashLabel.text = "Welcome!"
            UserDefaults.standard.set("opened", forKey: "isOpen")
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.performSegue(withIdentifier: "OpenMainScreen", sender: nil)
        }
    }
}
