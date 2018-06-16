//
//  SecondViewController.swift
//  FindThings
//
//  Created by Chris Lynn on 07/06/18.
//  Copyright © 2018 Chris Lynn. All rights reserved.
//

import UIKit


class ItemListVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    var tabBar = BaseTabbarController ()
    var itemsArr : NSArray = []
    @IBOutlet weak var itemTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar = self.tabBarController as! BaseTabbarController
        itemTbl.delegate=self
        itemTbl.dataSource=self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemsArr = tabBar.itemArr
        itemTbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell")
        cell?.textLabel?.text=itemsArr.object(at: indexPath.row) as? String
        return cell!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

