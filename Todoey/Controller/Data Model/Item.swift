//
//  Item.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/26/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateOfCreation : Date?
    //backward relationship in realm
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")  //"items" -> name of the forward relationship
}
