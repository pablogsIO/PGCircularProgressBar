//
//  ProgressBarConfiguration.swift
//  PGCircularProgressBar
//
//  Created by Pablo on 14/10/2018.
//  Copyright © 2018 Pablo Garcia. All rights reserved.
//

import Foundation

enum ProgressBarParameters: CaseIterable, Hashable {

    case attributedString
    case lineWidth
    case borderColor
    case borderWidth
}

struct ProgressBarConfiguration<Enum: CaseIterable & Hashable, Value> {
    private let values: [Enum: Value]

    init(resolver: (Enum) -> Value) {
        var values = [Enum: Value]()

        for key in Enum.allCases {
            values[key] = resolver(key)
        }

        self.values = values
    }

    subscript(key: Enum) -> Value {

        return values[key]!
    }
}
