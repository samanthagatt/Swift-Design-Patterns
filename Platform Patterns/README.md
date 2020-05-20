# Platform Patterns

## Delegation
* Key design pattern most closely related to Apple platform development
  * Hard to make any meaningful app without delegation
* Definition:
  * One object that is asked to respond to events that happened in another (or to guide its behavior)
* Most common example: `UITableView`'s `delegate` property
  * The table view will tell its delegate when specific events occur (e.g. when user taps on a cell)
* Removes the neccessity to subclass main object (e.g. `UITableView`)
  * Allows you to fully customize behavior without subclassing
* Main object and delegate object work together as one
  * Main object doesn't know what the delegate object is or how it works
* Main object should be generalized and designed to 
