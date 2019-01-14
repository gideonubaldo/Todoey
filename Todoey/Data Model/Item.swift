//
//  Item.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/13/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable { // or Codable
    var title : String = ""
    var done : Bool = false
}
