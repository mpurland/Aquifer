//
//  Auxiliary.swift
//  Aquifer
//
//  Created by Alexander Ronald Altman on 1/29/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

// roughly `Pipes.Extras`

import Foundation
import Swiftz

public func arr<A, B, R>(f: A -> B) -> Proxy<(), A, (), B, R> {
    return map(f)
}

private func leftInner<A, B, C>() -> Proxy<(), Either<A, C>, (), Either<B, C>, A> {
    return await() >>- {
        switch $0 {
        case let .Left(x): return pure(x.value)
        case let .Right(y): return yield(Either.right(y.value)) >>- { _ in leftInner() }
        }
    }
}

public func left<A, B, C, R>(p: Proxy<(), A, (), B, R>) -> Proxy<(), Either<A, C>, (), Either<B, C>, R> {
    return leftInner() >~ for_(p) { v in yield(Either.left(v)) }
}

private func rightInner<A, B, C>() -> Proxy<(), Either<C, A>, (), Either<C, B>, A> {
    return await() >>- {
        switch $0 {
        case let .Left(x): return yield(Either.left(x.value)) >>- { _ in rightInner() }
        case let .Right(y): return pure(y.value)
        }
    }
}

public func right<A, B, C, R>(p: Proxy<(), A, (), B, R>) -> Proxy<(), Either<C, A>, (), Either<C, B>, R> {
    return rightInner() >~ for_(p) { v in yield(Either.right(v)) }
}
