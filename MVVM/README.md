# MVVM (Model View ViewModel)

* Not that different from MVC
    * More like a variation of it

> **Presentation Model**
> * An object that stores the state of the app independently from the UI
> * Represents the associated view fully but without any attachment to `UIKit`/`AppKit`
    > * Reads and prepares data from model so it can be presented
    > * Makes it much easier to test because there's no interaction with UI elements
> * Apple's view controllers would be more like views than controllers with this architecture
    > * They should only dictate how to respond to events (e.g. implementing life cycle methods like `viewDidLoad`)
> * All presentation models should store the app state and views should display the state, but how do you get them synchronized?

## Data-Binding
* The Windows Presentation Foundation (WPF) framework uses data-binding for UI
    * e.g. connecting a string in the model to a text field in the view so changing either one will update the other
* MVVM was invented by Microsoft for WPF by taking the Presentation Model and adding data-binding
* Present in macOS (not iOS) but has 3 major problems
    * Relies heavily on Obj-C runtime
        * Must use classes marked with `@objc` and `@dynamic`
    * Stringly typed
        * Implementation requires you to input a string into Interface Builder that matches a property in your code
        * Very easy to make a mistake and not know why
    * Completely opaque
        * Values are adjusted automatically without you knowing how or why
        * Makes it extremely hard to debug
* Making data-binding easier for Apple platforms
    * Write your own binding code that keeps your view model in sync with your views
    * Use a library such as Bond that lets you say how values should be bound to views
    * Implement a large framework like RxSwift that includes binding
        * RxSwift is an incredibly different way of working
            * Not really a viable option if you only want data binding capabilities
