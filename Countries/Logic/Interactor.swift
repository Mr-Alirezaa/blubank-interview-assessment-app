//
//  Interactor.swift
//  Countries
//
//  Created by Alireza Asadi on 12/4/22.
//

import Foundation
import UIKit

protocol Interactor: AnyObject {
    associatedtype PresenterType: Presenter
    var presenter: PresenterType { get }
}

