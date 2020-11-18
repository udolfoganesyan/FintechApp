//
//  ParserProtocol.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 18.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}
