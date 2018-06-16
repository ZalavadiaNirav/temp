//
//  suggestionTblVC.swift
//  FindThings
//
//  Created by Nirav Zalavadia on 15/06/18.
//  Copyright © 2018 Chris Lynn. All rights reserved.
//

import UIKit

class suggestionTblVC: UITableViewController,UISearchResultsUpdating
{

    
    let searchController = UISearchController(searchResultsController: nil)
    var selectedIndex:Int = 0
    var candies = [Candy]()
    var unfilteredNFLTeams: [Candy]?
     var filteredNFLTeams: [Candy]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        candies = [Candy(category:"All",name:"property",attribute:["red","blue"]),
                   Candy(category: "All", name: "Project", attribute: ["black","blue"]),
                   Candy(category:"By Name",name:"name",attribute:["green","yellow"]),
                   Candy(category:"By Name",name:"name1",attribute:["green","yellow"]),
                   Candy(category: "By Attribute", name: "attribute1", attribute:["dark","orange"]),
                   Candy(category: "By Attribute", name: "attribute", attribute:["dark","orange"])]
        filteredNFLTeams = candies
        
//        searchController.searchResultsUpdater = self
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.dimsBackgroundDuringPresentation = true
//        searchController.searchBar.delegate = self
//        searchController.searchBar.sizeToFit()
//        searchController.searchBar.scopeButtonTitles=["All","By Name","By Attribute"]
//        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles=["All","By Name","By Attribute"]


    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.searchController.hidesNavigationBarDuringPresentation = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
    {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        //        return selectedIndex = selectedScope
        
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        unfilteredNFLTeams = candies.filter({( candy : Candy) -> Bool in
            let doesCategoryMatch = (scope == "All") || (candy.category == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let nflTeams = filteredNFLTeams else {
//            return 0
//        }
//        return nflTeams.count
//
        if isFiltering() {
            return unfilteredNFLTeams!.count
        }
        guard let nflTeams = unfilteredNFLTeams else {
            return 0
        }
        return nflTeams.count
    }
    
    //    public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
    //        if (filteredItemCount == totalItemCount) {
    //            setNotFiltering()
    //        } else if (filteredItemCount == 0) {
    //            label.text = "No items match your query"
    //            showFooter()
    //        } else {
    //            label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
    //            showFooter()
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let candy: Candy
        if isFiltering() {
            candy = unfilteredNFLTeams![indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        cell.textLabel!.text = candy.name
        //        cell.detailTextLabel!.text = candy.category
        
        
        //        if let nflTeams = unfilteredNFLTeams {
        //            let team = nflTeams[indexPath.row]
        //            cell.textLabel!.text = team.name
        //        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let candy: Candy
        if isFiltering() {
            candy = unfilteredNFLTeams![indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        print("\(candy)")
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredNFLTeams = unfilteredNFLTeams?.filter { Candy in
                return Candy.name.lowercased().contains(searchText.lowercased())
            }
        } else
        {
            filteredNFLTeams = unfilteredNFLTeams
        }
        self.tableView.reloadData()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

    }
}
