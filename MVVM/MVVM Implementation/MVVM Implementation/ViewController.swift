//
//  ViewController.swift
//  MVVM Implementation
//
//  Created by Samantha Gatt on 1/27/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

struct User {
    var name: Observable<String>
}

// Will want to change class to struct for the extra immutability (or move to Bond)
class Observable<ObservedType> {
    /// Stops an endless loop by avoiding calling the getter in the setter and vice versa
    private var _value: ObservedType {
        didSet {
            print(_value)
        }
    }
    var valueChanged: (ObservedType) -> Void = { _ in }
    var value: ObservedType {
        get {
            return _value
        }
        set {
            _value = newValue
            valueChanged(newValue)
        }
    }
    
    init(_ value: ObservedType) {
        _value = value
    }
    
    func bindingChanged(to newValue:  ObservedType) {
        _value = newValue
    }
}

// Subclassing UITextField since you can’t attach closures to any UIControl
class BoundTextField: UITextField {
    private var valueChangedClosure: () -> Void = { }
    
    @objc func valueChanged() {
        valueChangedClosure()
    }
    /// Sets value changed closures for both the observed object and the textfield
    func bind(to observable: Observable<String>) {
        text = observable.value
        valueChangedClosure = { [weak self] in
            observable.bindingChanged(to: self?.text ?? "")
        }
        observable.valueChanged = { [weak self] newValue in
            self?.text = newValue
        }
        addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: BoundTextField!
    
    private var user = User(name: Observable("Samantha Gatt"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.bind(to: user.name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.user.name.value = "Sammie"
        }
    }
}

