//
//  Goods.swift
//  R3piApp
//
//  Created by Капитан on 20.03.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import Foundation

enum Pack: String {
    case bag = "bag"
    case dozen = "dozen"
    case bottle = "bottle"
    case can = "can"
}

struct Goods {
    var title:String!
    var price:Double!
    var pack: Pack!
}
