//
//  LaunchViewController.swift
//  weatherApp
//
//  Created by Mix174 on 19.08.2021.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    private var anim0: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 192))
        imageView.image = UIImage(named: "anim0")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Launch did load")
        view.addSubview(anim0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Launch viewDidLayoutSubviews")
//        anim0.center = view.center
//        animate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Launch viewDidAppear")
        anim0.center = view.center
        animate()
    }
    
    private func animate() {
        for i in 1...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.anim0.image = UIImage(named: "anim\(i)")
                print("animate \(i)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
