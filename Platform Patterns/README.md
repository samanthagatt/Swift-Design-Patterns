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
    - Either expose your protocol to Objective-C and mark them as `optional` or provide default implementations in an extension

### Data Sources
* Specialized delegations that provide data rather than control behavior when an event occurrs
* No benefit in combining delegate and data source
  * Delegate and data source have different jobs so why combine them
* Act as a thin layer above the model to provide shaping before models are used

### SOLID
* **S**ingle responsibility
  * One object should be responsible for only one thing
* **O**pen/Closed
  * Should be open for extension but closed for modification
* **L**iskov substitution
  * Allows a subclass where its parent would be
* **I**nterface segregation
  * Having multiple small interfaces is better than one large one
* **D**ependency inversion
  * Depending on abstractions is better than depending on concrete things/objects
* Delegation is SOID
  * Instead of combining a lot of functionality into one class, objects that adopt the single responsibility of a delegate can be used
  * Adopts open/closed principle so main object can be customized through extensions without modifying the code, instead of forcing the main object to be subclassed to control its behavior *(L in SOLID)*
  * Delegate and data source are broken into two smaller interfaces, instead of combining them into one protocol
  * Main objects can use any object that conforms to the appropriate protocol to hold the delegate/data source, instead of relying on a specific class

### Suggestions
* Try to use protocols for delegates and data sources to reduce coupling
* Use `delegate` if there's only one or have the delegates end in `Delegate` if more than one
* Pass in object that triggered event as first parameter in delegate methods (to abide by Apple conventions)
* Main object should function without a delegate but can throw errors without a data source if need be
* Use protocol extensions to provide a default value for any optional methods (reccommended), or use `@objc` and mark it as optional
* Try to separate delegates and data sources as much as possible

## Selectors
* Swift closures wreak havoc on Objective-C
* Selectors are used instead
  * Like object oriented function pointers for Objective-C
  * Provide a generalized way to refer to functions and allow them to be used at some point in the future
  * Used as a way to send messages to objects instead of calling the function
* Selectors aren't enough to make a function call
  * What do you call the function on?
    * Objective-C uses **late binding** by default
      * If a message gets sent to an object that can't understand it, it can pass it along to another object
      * The final method that gets called at runtime might not be the one you meant to call
      * Looking up functions at runtime provides flexibility but is frowned upon in Swift because it is error prone and prevents the compiler from performing aggressive optimization so it results in slower performance
    * In Swift, target/selector pattern (temporarily) reverts back to Objective-C way of sending messages instead of calling methods
      * `@objc` asks Swift to expose the function to Objective-C so it can generate an Objective-C thunk method for it
      * **Objective-C thunk method**: a method that maps from the Objective-C way of calling functions to the Swift way
  * What arguments should you give it?
* Closures are preferable to selectors when you're making your own types/objects

### Target/Action
* Pretty much the only useful way to use selectors in Swift
  * Other uses are too unsafe to be beneficial unless you have a particularly troubling challenge
* Targets
  * What you can call the given function on
  * e.g. `UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))` will call something like `self.addsong()`
* Storyboards use this pattern when you create an IBAction
