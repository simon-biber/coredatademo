//
//  main.swift
//  coredatademo
//
//  Created by Simon Biber on 27/10/19.
//  Learning Core Data one step at a time.
//  https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
//
//  Thanks to David Everlöf @deverlof for tips to avoid using objects on
//  the wrong thread.
//
//  Go to Product, Scheme, Edit Scheme, Arguments and add the following
//  Arguments Passed on Launch:
//    -com.apple.CoreData.Logging.stderr 1
//    -com.apple.CoreData.ConcurrencyDebug 1
//  This will enable Core Data multi-threading assertions, making the
//  program stop whenever it accesses a Core Data object from the wrong
//  thread.

import Foundation
import CoreData

extension A {
    // Returns a string description of the object
    func simpleDescription(context: NSManagedObjectContext) -> String {
        var result = ""
        context.performAndWait {
            result = "A(b: \(b?.anything ?? "nil")"
                + ", c: \(c?.anything ?? "nil")"
                + ", d: \(d?.anything ?? "nil"))"
        }
        return result
    }
}

// Load the store for the model
let container = NSPersistentContainer(name: "Model")
container.loadPersistentStores { (description, error) in
    if let error = error {
        fatalError("Unable to load persistent stores: \(error)")
    }
}

// Note the container.viewContext can be used without performAndWait
// but it is documented as a read-only context. We want to modify the
// store so we use newBackgroundContext().
let context = container.newBackgroundContext()

// Fetch all the objects of type "A" from the store
var results = [Any]()
context.performAndWait {
    do {
        results = try context.fetch(NSFetchRequest(entityName: "A"))
    }
    catch {
        fatalError("Unable to fetch results: \(error)")
    }
}

if (results.count > 0) {
    // Loaded something. Print it out and delete it.
    print("Loaded \(results.count) items:")
    for result in results {
        let a = result as! A
        print(a.simpleDescription(context: context))
        context.performAndWait {
            context.delete(a)
        }
    }
    print("All deleted.")
}
else {
    // Nothing in the store. Let's add some things.
    print("Loaded nothing. Adding 3 items...")
    for i in 0..<3 {
        var a: A! = nil
        context.performAndWait {
            a = A(context: context)
            a.b = E(context: context)
            a.b?.anything = "foo\(i * 3 + 1)"
            a.c = E(context: context)
            a.c?.anything = "bar\(i * 3 + 2)"
            a.d = E(context: context)
            a.d?.anything = "baz\(i * 3 + 3)"
            context.insert(a)
        }
        print(a.simpleDescription(context: context))
    }
}

// Save the changes to the store
context.performAndWait {
    do {
        try context.save()
    }
    catch {
        fatalError(error.localizedDescription)
    }
}
print("Saved")
