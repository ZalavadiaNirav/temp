//
//  BaseTabbarController.swift
//  FindThings
//
//  Created by Chris Lynn on 10/06/18.
//  Copyright © 2018 Chris Lynn. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {
    
    var dataArr = [DataObject]()
    var structure = NSMutableArray()
    var itemArr = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
