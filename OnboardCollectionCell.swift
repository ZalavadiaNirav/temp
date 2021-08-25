//
//  OnboardCollectionCell.swift
//  RealtyDaddyAgent
//
//  Created by cnsoftnet on 08/04/20.
//  Copyright © 2020 cnsoftnet. All rights reserved.
//

import UIKit

class OnboardCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(onboardImg:UIImage)
    {
        DispatchQueue.main.async {
            self.imageVw.image=onboardImg
        }
    }
}
