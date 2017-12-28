//
//  Category.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/26/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object
{
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    // forwar relationship in realm
    
    let items = List<Item>()
}
