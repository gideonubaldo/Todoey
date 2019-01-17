//
//  Category.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/15/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
       @objc dynamic var color : String = ""
    //the category object now contains a list of items; forward relationship
    let items = List<Item>()
}
