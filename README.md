# coredatademo
In this project I'm learning how to load and save data using Core Data using Apple documentation
[Setting Up a Core Data Stack](https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack)

Thanks to David Everlöf [@deverlof](https://twitter.com/deverlof) for tips to avoid using objects on the wrong thread.

## Tip:
Go to Product, Scheme, Edit Scheme, Arguments and add the following Arguments Passed on Launch:
```
-com.apple.CoreData.Logging.stderr 1
-com.apple.CoreData.ConcurrencyDebug 1
```
This will enable Core Data multi-threading assertions, making the
program stop whenever it accesses a Core Data object from the wrong
thread.
