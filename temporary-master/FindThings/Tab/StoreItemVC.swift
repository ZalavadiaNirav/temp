//
//  StoreItemVC.swift
//  FindThings
//
//  Created by Chris Lynn on 08/06/18.
//  Copyright © 2018 Chris Lynn. All rights reserved.
//

import UIKit
import RATreeView



class  StoreItemVC: UIViewController , UIScrollViewDelegate , RATreeViewDelegate , RATreeViewDataSource, UIPickerViewDelegate , UIPickerViewDataSource , UITextFieldDelegate, passAttribute {
    
    var data:[DataObject] = NSArray() as! [DataObject]
    var treeView : RATreeView!
    var ParticularTree = DataObject(name: "")
    var places : NSMutableArray = []
    var selectedPlaces : String = ""
    var attributeArr : NSArray = []
    
    
    @IBOutlet weak var itemNameTxt: UITextField!
    @IBOutlet weak var placeTxt: UITextField!
    
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var placeScrollVw: UIScrollView!
    @IBOutlet weak var addAttributeBtn: UIButton!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var placesPicker: UIPickerView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        placeScrollVw.delegate=self
        places = NSMutableArray()
        self.extractPlaces()
    }
    
    func setupTreeView() -> Void
    {
        placeScrollVw.isHidden = false
        treeView = RATreeView(frame: self.view.bounds)
        treeView.register(UINib(nibName: String(describing: TreeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TreeTableViewCell.self))
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = UIView()
        treeView.backgroundColor = .clear
        treeView.tag=100
        treeView.frame = CGRect(x: 0, y:0, width:self.view.frame.size.width, height: treeView.frame.size.height)
        placeScrollVw.contentSize=CGSize(width: self.view.frame.size.width, height: (treeView.frame.size.height))
        placeScrollVw.addSubview(treeView)
        placeScrollVw.bringSubview(toFront: treeView)
        treeView.reloadData()
    }
    
    func extractPlaces()
    {
        let tabBar = tabBarController as! BaseTabbarController
        
        for index in 0...tabBar.structure.count-1
        {
            let placeArr = tabBar.structure
            let dict = placeArr[index] as? NSMutableDictionary
            let placeStr = dict!["name"] as? String
            places.insert(placeStr!, at: index)
        }
        print("places array = \(places)")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == placeTxt)
        {
            textField.resignFirstResponder()
            placeTxt.text=""
            placeScrollVw.isHidden = true
        //self.treeView.isHidden = true
            placesPicker.isHidden = false
            toolbar.isHidden = false
            
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    func passAttributes(attributeArr: NSArray)
    {
        self.attributeArr=attributeArr
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return places.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return places[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedPlaces = (places[row] as? String)!
    }
    
    @IBAction func storeAction(_ sender: Any)
    {
        if ((itemNameTxt.text?.isEmpty)! || (placeTxt.text?.isEmpty)!)
        {
            let msg = UIAlertController(title: "Fill up", message: "Please enter Name and Place", preferredStyle: UIAlertControllerStyle.alert)
            let aleartAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            msg.addAction(aleartAction)
            self.present(msg, animated: true, completion: nil)
        }
        else
        {
            if(self.ParticularTree.children.count==0)
            {
                let tabBar = tabBarController as! BaseTabbarController
                let itemName = itemNameTxt.text
                tabBar.itemArr.add(itemName)
                
                let placeArr = tabBar.structure
                for index in 0...placeArr.count-1
                {
                    let dict1 : NSMutableDictionary = placeArr[index] as! NSMutableDictionary
                    let nameStr : String = dict1["name"] as! String
                    let placeStr : String = placeTxt.text!
                    if(nameStr == placeStr)
                    {
                        let childArr = NSMutableArray()
                        childArr.add(self.itemNameTxt.text as! String)
                        dict1["child"] = childArr
                        break
                    }
                }
                print("structure=\(tabBar.structure)")
                
                print("itemArray=\(tabBar.itemArr.description)")
                self.createItemModel(ChildName: "", ParentName:self.placeTxt.text!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func createItemModel(ChildName:String,ParentName:String)
    {
        
        let tabBar = tabBarController as! BaseTabbarController
        
        print(ParentName,ChildName)
        
//        var childName:String
//
//        for ind in 0...ParticularTree.children.count-1
//        {
//            let child = ParticularTree.children[ind]
//            print(child.name)
//
//        }
        
        self.extractChild(child:[ParticularTree])
        
        
//        let mItem = itemModel(name: itemNameTxt.text!, storedAt: tabBar.itemArr, attributes: attributeArr)
//        print(mItem)
    }
    
    @IBAction func AddAttributeAction(_ sender: Any)
    {
//        if let nav = .destination as? UINavigationController, let classBVC = nav.topViewController as? ClassBVC {
//            classBVC.delegate = self
//        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let objAttribute = storyBoard.instantiateViewController(withIdentifier: "attributeID") as! AttributeVC
        objAttribute.delegate=self
        self.navigationController?.pushViewController(objAttribute, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if let nav = segue.destination as? UINavigationController, let objAttributeVC = nav.topViewController as? AttributeVC
//        {
//            objAttributeVC.delegate = self
//        }
//        
//    }
    
    
    //MARK: picker methods
    
    @IBAction func doneAction(_ sender: Any)
    {
        toolbar.isHidden=true
        placesPicker.isHidden=true
        placeTxt.text = selectedPlaces
        
        
        let tabBar = tabBarController as! BaseTabbarController
        if(tabBar.dataArr.count != 0)
        {
            for ind in 0...tabBar.dataArr.count-1
            {
                let pname = tabBar.dataArr[ind].name
                if(pname == placeTxt.text)
                {
                    ParticularTree=tabBar.dataArr[ind]
                }
            }
        }
        
        print("parent aray=\(ParticularTree)")
        
        self.setupTreeView()
        treeView.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        toolbar.isHidden=true
        placesPicker.isHidden=true
        placeTxt.text = ""
    }
    
    
    //MARK: RATreeView data source
    
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int
    {
        if let item = item as? DataObject {
            return item.children.count
        }
        else {
            return self.ParticularTree.children.count
        }
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any
    {
        if let item = item as? DataObject {
            return item.children[index]
        }
        else {
            return ParticularTree.children[index] as AnyObject
        }
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell
    {
        let cell = treeView.dequeueReusableCell(withIdentifier: String(describing: TreeTableViewCell.self)) as! TreeTableViewCell
        let item = item as! DataObject
        
        let level = treeView.levelForCell(forItem: item)
        let detailsText = "Number of children \(item.children.count)"
        cell.selectionStyle = .none
        cell.setup(withTitle: item.name, detailsText: detailsText, level: level, additionalButtonHidden: false)
        
        cell.additionButtonActionBlock = { [weak treeView] cell in
            
            let item=(treeView?.item(for: cell) as! DataObject)
            
            
            print("item stored here=\(treeView?.item(for: cell) as! DataObject)")
            
            let stored = UIAlertController(title:"Successfully Stored", message:"Your Item is stored In\(item.name)", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title:"Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
//                let tabBar = self.tabBarController as! BaseTabbarController
//                tabBar.itemArr
                self.navigationController?.popViewController(animated: true)
            })
            
            stored.addAction(action)
            self.present(stored, animated: true, completion:
            {
                guard let treeView = treeView else {
                    return;
                }
                let item = treeView.item(for: cell) as! DataObject
//                self.iterate(item: item)
                let tabBar = self.tabBarController as! BaseTabbarController
                let placeArr = tabBar.structure
                for index in 0...placeArr.count-1
                {
                    let dict = placeArr[index] as? NSMutableDictionary
                    if let childArr = dict?["child"] as? NSMutableArray
                    {
                        if(childArr.count != 0)
                        {
                            for m in 0...((childArr.count)-1)
                            {
                                let childItem = childArr[m] as! String
                                if(childItem == item.name)
                                {
                                    
                                    
//                                    self.iterate(item: item)
                                    childArr.add(self.itemNameTxt.text as! String)
                                    tabBar.itemArr.add(self.itemNameTxt.text as! String)
                                    self.createItemModel(ChildName:item.name, ParentName:self.placeTxt.text!)
                                    break
                                }
                            }
                        }
                    }
                }
                print("tab=\(tabBar.structure)")
                
            })
            

        }
        return cell
    }
    
    func extractChild(child:[DataObject])
    {
        for index in 0...child.count-1
        {
            let parent = child[index]
            if(parent.name == "Phone 4")
            {
                break;
            }
            print("name=\(parent.name)")
            let child:[DataObject] = parent.children
            
            if(child.count != 0)
            {
                if(parent.name != "Phone 4")
                {
                    print("child")
                    extractChild(child:child)
                }
            }
        }
    }

    
//    func iterate(item:DataObject)
//    {
//        for ind in 0...self.data.count-1
//        {
//            let parent = self.data[ind]
//            let child = self.data[ind].children
//        }
//
//
//        let name = item.name
//
//
//
////        self.extractChild(child: [item], Px: 0, Py: &0)
//    }
    
    //MARK: RATreeView delegate
    
    func treeView(_ treeView: RATreeView, commit editingStyle: UITableViewCellEditingStyle, forRowForItem item: Any) {
        guard editingStyle == .delete else { return; }
        let item = item as! DataObject
        let parent = treeView.parent(forItem: item) as? DataObject
        
        let index: Int
        if let parent = parent {
            index = parent.children.index(where: { dataObject in
                return dataObject === item
            })!
            parent.removeChild(item)
            
        } else {
            index = self.data.index(where: { dataObject in
                return dataObject === item;
            })!
            self.data.remove(at: index)
        }
        
        self.treeView.deleteItems(at: IndexSet(integer: index), inParent: parent, with: RATreeViewRowAnimationRight)
        if let parent = parent {
            self.treeView.reloadRows(forItems: [parent], with: RATreeViewRowAnimationNone)
        }
    }
    
    static func commonInit() -> [DataObject] {
        let phone1 = DataObject(name: "Phone 1")
        let device1 = DataObject(name: "Device 1")
        
        //        let phone11 = DataObject(name: "Devies",children:[device1])
        
        
        let phone2 = DataObject(name: "Phone 2")
        let phone3 = DataObject(name: "Phone 3")
        let phone4 = DataObject(name: "Phone 4")
        let phones = DataObject(name: "Phones", children: [phone1, phone2, phone3, phone4])
        
        
        let notebook1 = DataObject(name: "Notebook 1")
        let notebook2 = DataObject(name: "Notebook 2")
        
        let computer1 = DataObject(name: "Computer 1", children: [notebook1, notebook2])
        let computer2 = DataObject(name: "Computer 2")
        let computer3 = DataObject(name: "Computer 3")
        let computers = DataObject(name: "Computers", children: [computer1, computer2, computer3])
        
        let cars = DataObject(name: "Cars")
        let bikes = DataObject(name: "Bikes")
        let houses = DataObject(name: "Houses")
        let flats = DataObject(name: "Flats")
        let motorbikes = DataObject(name: "motorbikes")
        let drinks = DataObject(name: "Drinks")
        let food = DataObject(name: "Food")
        let sweets = DataObject(name: "Sweets")
        let watches = DataObject(name: "Watches")
        let walls = DataObject(name: "Walls")
        
        return [phones, computers, cars,
                bikes, houses, flats, motorbikes, drinks, food, sweets, watches, walls]
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
