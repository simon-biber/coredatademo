//
//  main.swift
//  coredatademo
//
//  Created by Simon Biber on 27/10/19.
//  Copyright © 2019 Simon Biber. All rights reserved.
//

import Foundation
import CoreData

let container = NSPersistentContainer(name: "Model")
container.loadPersistentStores { (description, error) in }
let model = container.managedObjectModel
let context = container.newBackgroundContext()
let results = try context.fetch(NSFetchRequest(entityName: "A"))

if (results.count > 0) {
    for result in results {
        let a = result as! A
        print("A(b:",
            a.b?.anything ?? "nil",
            ", c:",
            a.c?.anything ?? "nil",
            ", d:",
            a.d?.anything ?? "nil",
            ")")
    }
}
else {
    let a = A(context: context)
    a.b = E(context: context)
    a.b?.anything = "foo"
    a.c = E(context: context)
    a.c?.anything = "bar"
    a.d = E(context: context)
    a.d?.anything = "baz"
    context.insert(a)
    try context.save()
    print("Saved")
}
