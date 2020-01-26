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
        * Results in the view controller conforming to a list of different protocols\
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

## MVP (Model View Presenter)
* Similar alternative to MVC
    * **Model:** Stores data
    * **View:** Stores passive UI elements that forward user input to the presenter
    * **Presenter:** Reads data from model, formats it, then displays it in views
* Apple’s implementation of MVC seems more like MVP

