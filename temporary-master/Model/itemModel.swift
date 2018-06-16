//
//  itemModel.swift
//  FindThings
//
//  Created by Chris Lynn on 15/06/18.
//  Copyright © 2018 Chris Lynn. All rights reserved.
//

import Foundation

class itemModel {
    
    let itemName:String
    let storedArr:NSArray
    let attributesArr:NSArray
    
    init(name:String,storedAt:NSArray,attributes:NSArray) {
        itemName=name
        storedArr=storedAt
        attributesArr=attributes
    }
}

