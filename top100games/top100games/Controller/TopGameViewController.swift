//
//  ViewController.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 20/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import UIKit

class TopGameViewController: UIViewController {
    
    var networkProvider: Networkable!
    
    init(networkProvider: Networkable) {
        super.init(nibName:nil, bundle: nil)
        self.networkProvider = networkProvider
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        networkProvider.getTopGames() {
            games in
                print("works")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

