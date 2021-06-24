//
//  TabBarController.swift
//  Instagram
//
//  Created by Nuthan Raju Pesala on 16/05/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var users = ["Raju","Ajay","Naveen","Pavan"]

        func searchArray(text: String)-> [String] {
            users = users.filter({$0.first?.lowercased() == text.lowercased()})
            return users
        }

        let x = searchArray(text: "P")
        print(x)
    }
    

  

}
