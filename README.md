# Swift Design Patterns
Book by Paul Hudson
(Notes by me)

## Intro
* Coupling
    * How dependent pieces of your code are to each other
    * Aim for loosely coupled code (not tightly)
* Swift is aggressively value-oriented
    * Relies heavily on values not references/pointers (struct vs class)
    * Classes cause tight coupling
        * Creates multiple implicit dependency because they can have a variety of owners (structs can only have one since they get copied and passed as an entirely different object in memory)
    * Inheritance causes the tightest coupling
        * A child class is completely reliant on its parent class
            * One small change in the parent can disrupt the entire child class

## MVC (Model View Controller)
* Separates concerns of your architecture so each component does only one thing (decouples M, V, and C)
    * **Model:** Stores data
    * **View:** Displays the data
    * **Controller:** Responds to and manipulates model
        * Arranges views
        * Handles user input back and forth
        * Edits data/model
* Common usage is not accurate MVC
    * Usually people make a model and handle everything else in the controller (e.g. UIViewController)
        * Where the nickname Massive View Controller comes from
        * UITableViewController couples the View and Controller together so the controller has multiple jobs
* Apple developers rely heavily on MVC
    * Xcode templates assume you’ll be using MVC
    * Most built-in APIs are designed around MVC
        * Causes MVC to be the easiest choice for developing small apps because setting the code up for a different architecture will be just as hard as making the actual app

### Advantages
* One of the most common architectures
    * Implemented in millions of programs
    * Most everyone knows the term MVC
* It’s very clear what role each component has
    * Even beginners will know what role each piece is supposed to perform
    * Makes it easy to start on a project since it provides such a clear separation of concerns
* Has clear data flow
* How UIKit, AppKit, and WatchKit were designed

### Disadvantages
* View controllers frequently become very large and confusing
    * MVC makes it easy to add code to it even if it’s not the best place for it
        * Results in the view controller conforming to a list of different protocols
    * The word “controller” implies nothing is out of scope to be included since its role is to control things (the biggest responsibility)
* Separation of concerns tend to blur
    * Should code to format data be held in the model, view, or controller?
    * Well known culprit is `cellForRowAt` method
        * Whose job should it be to create and prepare cells to be displayed?
* View Controllers are quite hard to test
    * Any logic will be much harder to test when it’s in contact with the UI
* Tends to result in small models and views
    * Usually a tiny M, even smaller V, and huge C
* Doesn’t adequately answer other concerns such as
    * Where do I put networking code?
    * How do I control the flow of my app?

### Fixing it
#### Using more than one controller
* There doesn't need to be only one controller in the app or even per screen
   * Creating multiple controllers separated by functionality will alleviate the "massive view controller" concern
* Apple's view controller containment makes it easy to add/remove child `ViewController`s
    * Reusable extension to make it even easier
    ```swift
    // `@nonobjc` is used so it won't conflict with any Apple code
    @nonobjc extension UIViewController {
        func add(_ child: UIViewController, frame: CGRect? = nil) {
            addChildViewController(child)
            if let frame = frame {
                child.view.frame = frame
            }
            view.addSubview(child.view)
            child.didMove(toParentViewController: self)
        }
        func remove() {
            willMove(toParentViewController: nil)
            view.removeFromSuperview()
            removeFromParentViewController()
        }
    }
    ```
    * Use cases
        *  Most popular when you need to overlay one vc temporarily over top of another
        * If one part of your screen is only loosely related to another
            * Similar to `UISplitViewController`
    * Good resource for view controller containment
        * https://www.swiftbysundell.com/articles/custom-container-view-controllers-in-swift/
#### Delegation
* Creating dedicated classes to act as data sources and delegates helps isolate functionality and increase testability
* e.g. `ChildFriendlyWebDelegate`
    ```swift
    class ChildFriendlyWebDelegate: NSObject, WKNavigationDelegate {
        var childFriendlySites = ["apple.com", "google.com"]
        
        // Much easier to test the logic
        // You don't need to make a mock webView like you would for the method below
        func isAllowed(url: URL?) -> Bool {
            guard let host = url?.host else { return false }
            if childFriendlySites.contains(where: host.contains) {
                return true
            }
            return false
        }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if isAllowed(url: navigationAction.request.url) {
                decisionHandler(.allow)
            }
            decisionHandler(.cancel)
        }
    }
    
    // Implementation
    class ViewController: UIViewController {
        @IBOutlet var webView: WKWebView!
        
        func viewDidLoad(animated: Bool) {
            super.viewDidLoad(animated: true)
            webView.navigationDelegate = ChildFriendlyWebDelegate()
        }
    }
    ```

#### Make use of `UIView`
* Coding your user interface is perfectly fine, but do it in a UIView subclass
    * All code relating to setting up and styling subviews should be handled in the parent `UIView` class
    ```swift
    class MyView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            createSubviews()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            createSubviews()
        }
        func createSubviews() {
            // all the layout code for subviews so it's not in the viewController's `viewDidLoad`
        }
    }
    
    // Implementation
    class ViewController: UIViewController {
        var shareView = SharePromptView()

        override func loadView() {
            view = shareView
        }
    }
    ```
#### Avoid the `AppDelegate`
* Don't dump unrelated code in the app delegate
    * It’s almost never the right place for it
    * Stick to implementing `UIApplicationDelegate` protocol methods in the `AppDelegate`

## MVP (Model View Presenter)
* Similar alternative to MVC
    * **Model:** Stores data
    * **View:** Stores passive UI elements that forward user input to the presenter
    * **Presenter:** Reads data from model, formats it, then displays it in views
* Apple’s implementation of MVC seems more like MVP
