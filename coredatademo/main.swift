//
//  main.swift
//  coredatademo
//
//  Created by Simon Biber on 27/10/19.
//  Learning Core Data one step at a time.
//  https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
//

import Foundation
import CoreData

extension A {
    func simpleDescription() -> String {
        return "A(b: \(b?.anything ?? "nil")"
            + ", c: \(c?.anything ?? "nil")"
            + ", d: \(d?.anything ?? "nil"))"
    }
}

let container = NSPersistentContainer(name: "Model")
container.loadPersistentStores { (description, error) in
    if let error = error {
        fatalError("Unable to load persistent stores: \(error)")
    }
}
let context = container.viewContext
let results = try context.fetch(NSFetchRequest(entityName: "A"))

if (results.count > 0) {
    // Loaded something. Print it out and delete it.
    print("Loaded \(results.count) items:")
    for result in results {
        let a = result as! A
        print(a.simpleDescription())
        context.delete(a)
    }
    print("All deleted.")
}
else {
    // Nothing in the store. Let's add some things.
    print("Loaded nothing. Adding 3 items...")
    for i in 0..<3 {
        let a = A(context: context)
        a.b = E(context: context)
        a.b?.anything = "foo\(i * 3 + 1)"
        a.c = E(context: context)
        a.c?.anything = "bar\(i * 3 + 2)"
        a.d = E(context: context)
        a.d?.anything = "baz\(i * 3 + 3)"
        context.insert(a)
        print(a.simpleDescription())
    }
}

do {
    try context.save()
    print("Saved")
}
catch {
    fatalError(error.localizedDescription)
}

