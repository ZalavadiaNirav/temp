//
//  OnboardVC.swift
//  RealtyDaddyAgent
//
//  Created by cnsoftnet on 07/04/20.
//  Copyright © 2020 cnsoftnet. All rights reserved.
//

import Foundation
import UIKit
import PageControls
import LGSideMenuController

class OnboardVC : UIViewController
{
    let cellIdentifier = "OnboardCellID"
    
    @IBOutlet weak var onboardCollectionVw: UICollectionView!
    @IBOutlet weak var pageControl: PillPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    
    override func viewDidLoad() {
        self.setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update scroll view content size.
        let contentSize = CGSize(width:onboardCollectionVw.bounds.width * CGFloat(kOnboardTotalCount),height: onboardCollectionVw.bounds.height)
        onboardCollectionVw.contentSize = contentSize
    }
    
    func setupCollectionView()
    {
        self.onboardCollectionVw.delegate=self
        self.onboardCollectionVw.dataSource=self
        self.onboardCollectionVw.isPagingEnabled=true
        onboardCollectionVw.register(UINib.init(nibName: "OnboardCollectionCell", bundle:nil), forCellWithReuseIdentifier:cellIdentifier)

        pageControl.progress=0.0
        pageControl.pageCount=kOnboardTotalCount
    }
    
    func pageCount(currentPage:Int)
    {
        //print("currentpage=\(currentPage)")
        pageControl.progress=CGFloat(currentPage)
        skipBtn.setTitle("Skip", for: UIControl.State.normal)
       
        if(currentPage == 0){
            previousBtn.isHidden = true
        }
        else if(currentPage == kOnboardTotalCount-1)
        {
            skipBtn.setTitle("Done", for: UIControl.State.normal)
            nextBtn.isHidden = true
        }
        else {
            nextBtn.isHidden = false
            previousBtn.isHidden = false
        }
    }
    
    ///MARK: IBACTION
    
    @IBAction func nextAction(_ sender: Any) {
        
        let pageWidth = onboardCollectionVw.frame.size.width
        let currentPage = floor((onboardCollectionVw.contentOffset.x-pageWidth/CGFloat(kOnboardTotalCount))/pageWidth)+1
        if(Int(currentPage) < kOnboardTotalCount)
        {
            previousBtn.isHidden = false
            let scrollToInd = NSIndexPath(row: Int(currentPage+1), section:0)
            onboardCollectionVw.scrollToItem(at: scrollToInd as IndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            pageCount(currentPage: Int(currentPage+1))
        }
        else
        {
            self.navigateToDashboard()
        }
    }
    
    @IBAction func skipAction(_ sender: Any) {
       
        self.navigateToDashboard()
    }
    
    func navigateToDashboard()
    {
        UserDefaults.standard.set(true, forKey: "isLaunch")
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "DashboardVC")], animated: false)

               
       let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
               mainViewController.rootViewController = navigationController
               mainViewController.setup(type: UInt(1))
                
        let appDelegate = AppDelegate.shared!
        
        appDelegate.window?.rootViewController = mainViewController

        UIView.transition(with: appDelegate.window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        
    }
    
    @IBAction func previousBtn(_ sender: Any) {
        let pageWidth = onboardCollectionVw.frame.size.width
        
          let currentPage = floor((onboardCollectionVw.contentOffset.x-pageWidth/CGFloat(kOnboardTotalCount))/pageWidth)+1
          if(Int(currentPage) >= 0)
          {
              nextBtn.isHidden = false
              let scrollToInd = NSIndexPath(row: Int(currentPage-1), section:0)
              onboardCollectionVw.scrollToItem(at: scrollToInd as IndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
              pageCount(currentPage: Int(currentPage-1))
          }
    }
}


extension OnboardVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kOnboardTotalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellIdentifier, for: indexPath) as? OnboardCollectionCell
        cell?.configureCell(onboardImg: UIImage.init(imageLiteralResourceName: "img3"))
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.onboardCollectionVw.frame.size.width, height: self.onboardCollectionVw.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension OnboardVC : UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let page = scrollView.contentOffset.x / scrollView.bounds.width
        self.pageCount(currentPage: Int(page))
    }
}

