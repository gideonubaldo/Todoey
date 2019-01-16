//
//  Item.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/15/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //each Item has a parentCategory from Category called form property called items; inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
