//
//  Grouping.swift
//  Aquifer
//
//  Created by Alexander Ronald Altman on 1/18/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

import Foundation
import Swiftz

internal enum GroupedProducerSignature<V, R> {
    case End(() -> R)
    case More(() -> Proxy<X, (), (), V, GroupedProducer<V, R>>)
}

public struct GroupedProducer<V, R> {
    internal let underlying: GroupedProducerSignature<V, R>

    internal init(_ u: GroupedProducerSignature<V, R>) {
        underlying = u
    }
}

public func groupsBy<V, R>(p: Proxy<X, (), (), V, R>, equals: (V, V) -> Bool) -> GroupedProducer<V, R> {
    
}

public func groups<V: Equatable, R>(p: Proxy<X, (), (), V, R>) -> GroupedProducer<V, R> {
    return groupsBy(p, ==)
}