//
//  FirstViewController.swift
//  Sample
//
//  Created by kamal saboo on 25/05/18.
//  Copyright © 2018 Viral. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    static var bdFV : BDFirstViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        return storyboard.instantiateViewController(withIdentifier: "bdFirstVC") as! BDFirstViewController

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded ")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nextBtnClicked(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        bdFV = storyboard.instantiateViewController(withIdentifier: "bdFirstVC") as! BDFirstViewController
        navigationController?.pushViewController(FirstViewController.bdFV, animated: true)
    }
}
