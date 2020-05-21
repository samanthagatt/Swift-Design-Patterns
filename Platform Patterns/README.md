# Platform Patterns

## Delegation
* Key design pattern most closely related to Apple platform development
  * Hard to make any meaningful app without delegation
* Definition:
  * One object that is asked to respond to events that happened in another (or to guide its behavior)
  * One generalized object and one specialized object working in tandem
* Most common example: `UITableView`'s `delegate` property
  * The table view will tell its delegate when specific events occur (e.g. when user taps on a cell)
* Removes the neccessity to subclass main object (e.g. `UITableView`)
  * Allows you to fully customize behavior without subclassing
* Main object and delegate object work together as one
  * Main object doesn't know what the delegate object is or how it works
* Main object should be generalized and designed to handle all events related to its function
* Delegate object should be unique to the coding problem you're facing
* **Makes it easy to customize behavior of objects while minimizing coupling**
* The delegate object should be a specialized, custom object specifically designed to respond as the delegate

### Design Rules
1. Name the property in the main object `delegate` if there is only one
    - If more than one: put delegate at the end (e.g. `uiDelegate` and `navigationDelegate` for `WKWebView`)
2. Decide which points will need to notify the delegate before coding
    - There's a small cost for each check to see if there's a delegate and whether or not it cares about an event
3. Avoid verb conjugation when naming delegate methods
    - Many methods will begin with `will`, `did`, and `should`
4. To maintain lower coupling, use a protocol for the delegate and implement it with an object (class or struct)
5. Allow your delegate object to only implement the methods it wishes wherever possible
    - Either expose your protocol to Objective C and mark them as `optional` or provide default implementations in an extension

## Data Sources
* Specialized delegations that provide data rather than control behavior when an event occurrs
* No benefit in combining delegate and data source
  * Delegate and data source have different jobs so why combine them
* Act as a thin layer above the model to provide shaping before models are used
