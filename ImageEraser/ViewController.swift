//
//  ViewController.swift
//  ImageEraser
//
//  Created by Haykaz Melikyan on 02.04.22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var eraseView: EraseImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        eraseView.backgroundImage = #imageLiteral(resourceName: "back")
        eraseView.setForegroundImage(#imageLiteral(resourceName: "front"))
    }

    @IBAction func eraseTypeChangeSegmentAction(_ sender: UISegmentedControl) {
        eraseView.setTouchRevealsImage(sender.selectedSegmentIndex != 0)
    }

}

