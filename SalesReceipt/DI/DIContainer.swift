//
//  DIContainer.swift
//  SalesReceipt
//
//  Created by Quasar on 24.01.2025.
//

import Foundation
protocol DependencyConfigurable {
    static func create(container: DIContainer) -> Self
}

final class DIContainer {
    static let shared = DIContainer()
    private var dependencies: [String: Any] = [:]

    func register<T>(_ type: T.Type, _ dependency: T) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = dependencies[String(describing: type)] as? T else {
            fatalError("Dependency for \(type) not registered")
        }
        return dependency
    }

    func build<T: DependencyConfigurable>(type: T.Type) -> T {
        return T.create(container: self)
    }
}
