# MVVM (Model View ViewModel)

* Not that different from MVC
    * More like a variation of it

> **Presentation Model**
> * An object that stores the state of the app independently from the UI
> * Represents the associated view fully but without any attachment to `UIKit`/`AppKit`
>     * Reads and prepares data from model so it can be presented
>     * Makes it much easier to test because there's no interaction with UI elements
> * Apple's view controllers would be more like views than controllers with this architecture
>     * They should only dictate how to respond to events (e.g. implementing lifecycle methods like `viewDidLoad`)
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

## Advantages
* Biggest advantage is how much easier it makes testing
   * Unit tests can be smaller and less complicated since there are no UI elements in the ViewModel
   * Can provide the smaller view controller with mock ViewModels during testing without having to use live data
* Frees up view controller so it can focus on responding to lifecycle events
* Separates responsibilities reasonably well enough that beginners can understand it
   * **Model:** stores data
   * **View:** stores visual representations of data
   * **ViewModel:** stores everything else
* Has clear data flow as long as bindings aren't too hard
   * Connects view model directly to views using two-way binding
   * ViewModel manipulates your model
   * View controller does next to nothing as nature intended

## Disadvantages
* Biggest disadvantage is a lot of boiler plate code is needed if you're not using data-binding
   * Complexity will increase when using binding frameworks
* Models are still usually very small (not much code goes into them)
* Introduces complexity for smaller projects
   * None of Apple's templates use MVVM so you will need to implement bindings or shuttle data to and from the ViewModel yourself each time
* Pretty much just moves the duping ground for code from the controller (in MVC) to the ViewModel
   * Common to find networking code, input/output, validation, and more all in the ViewModel

## VM of MVVM
* The ViewModel wraps the entire model to prepare for visualization (without any actual UI code)
   * The view should have no idea the model even exists
* Formats model properties/values
   * e.g. Converting a `Date` to a `String` so it can be displayed
* Archives and Dearchives model data
* Networking code
* Data validation
   * Can also be done in model
   
