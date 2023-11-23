//
//  WelcomeUserViewController.swift
//  CoreDataPractice
//
//  Created by 홍세희 on 2023/11/23.
//

import UIKit

class WelcomeUserViewController: UIViewController {
    
    @IBOutlet var id: UILabel!
    var showIdentifier: String = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = showIdentifier
        self.navigationController?.navigationBar.isHidden = true
//        id.text = "메롱"
        
        // Do any additional setup after loading the view.
    }

}
