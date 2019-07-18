//
//  ViewController.swift
//  TimeToFeed
//
//  Created by nguyen.trong.hieu on 7/16/19.
//  Copyright © 2019 nguyen.trong.hieu. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let controller = ScreenViewController(nibName: "ScreenViewController", bundle: nil)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        self.addChild(controller)
    }
}

