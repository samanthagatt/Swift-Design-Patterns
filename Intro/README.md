# Intro

## Coupling
* How dependent pieces of your code are to each other
* You should aim for loosely coupled code (instead of tightly coupled)

## Value-Orientation
* Swift relies heavily on values not references
* Structs are value based whereas classes are reference based
    * Classes cause tight coupling
        * Creates multiple implicit dependency because they can have a variety of owners (structs can only have one since they get copied and passed as an entirely different object in memory)
    * Inheritance causes the tightest coupling
        * A child class is completely reliant on its parent class
            * One small change in the parent can disrupt the entire child class
