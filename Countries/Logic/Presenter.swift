//
//  Presenter.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import UIKit

protocol Presenter: AnyObject {
    associatedtype ViewControllerType: UIViewController
    var controller: ViewControllerType? { get }
}
