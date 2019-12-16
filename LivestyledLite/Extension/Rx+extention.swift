import RxSwift
import RxCocoa
import Foundation
extension ObservableType {
    
    func mapVoid() -> Observable<Void> {
        return self.mapConst(())
    }
    
    func mapConst<T>(_ value: T) -> Observable<T> {
        return self.map { _ in value }
    }
    
    func map<Value>(_ kp: KeyPath<E, Value>) -> Observable<Value> {
        return map { $0[keyPath: kp] }
    }
    
    func filterMap<Value>(_ kp: KeyPath<E, Value?>) -> Observable<Value> {
        return map(kp).unwrap()
    }
    
}

/// As signal
extension ObservableType {
    
    func asSignalOnErrorJustCompleted() -> Signal<E> {
        return asSignal(onErrorSignalWith: .empty())
    }
    
    func asSignalOnErrorJustIgnored() -> Signal<E> {
        return asSignal(onErrorSignalWith: .never())
    }
    
}

/// As driver
extension ObservableType {
    
    func asDriverOnErrorJustCompleted() -> Driver<E> {
        return asDriver(onErrorDriveWith: .empty())
    }
    
    func asDriverOnErrorJustIgnored() -> Driver<E> {
        return asDriver(onErrorDriveWith: .never())
    }
    
}

extension ObservableType where E: OptionalType {
    
    func onOptionalJustReturn(_ value: E.Wrapped) -> Observable<E.Wrapped> {
        return map { current in
            return current.optional ?? value
        }
    }
    
}

extension SharedSequenceConvertibleType {
    
    func mapVoid() -> SharedSequence<SharingStrategy, Void> {
        return self.mapConst(())
    }
    
    func mapConst<T>(_ value: T) -> SharedSequence<SharingStrategy, T> {
        return self.map { _ in value }
    }
    
    func map<Value>(_ kp: KeyPath<E, Value>) -> SharedSequence<SharingStrategy, Value> {
        return self.map { $0[keyPath: kp] }
    }
    
}

extension ObservableType where E == String? {
    
    func orEmpty() -> Observable<String> {
        return self.map { text in
            if let text = text {
                return text
            } else {
                return ""
            }
        }
    }
    
}

extension ObservableType {
    
    func debugInMarco(
        _ identifier: String? = nil,
        trimOutput: Bool = false,
        file: String = #file,
        line: UInt = #line,
        function: String = #function)
        -> Observable<E>
    {
        #if DEBUG
        return debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
        #else
        return self.asObservable()
        #endif
    }
    
}

extension ObservableType where E: EventConvertible {
    
    /**
     Returns an observable sequence containing only next elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func elements() -> Observable<E.ElementType> {
        return filter { $0.event.element != nil }
            .map { $0.event.element! }
    }
    
    /**
     Returns an observable sequence containing only error elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func errors() -> Observable<Swift.Error> {
        return filter { $0.event.error != nil }
            .map { $0.event.error! }
    }
}

extension ObservableType where E: OptionalType {
    
    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     
     - returns: An observable sequence of non-optional elements
     */
    
    func unwrap() -> Observable<E.Wrapped> {
        return self
            .filter { value in
                if case .some = value.optional {
                    return true
                }
                return false
            }
            .map { $0.forceUnwrap() }
    }
}

extension SharedSequenceConvertibleType where E: OptionalType {
    
    func unwrap() -> SharedSequence<SharingStrategy, E.Wrapped> {
        return self
            .filter { value in
                if case .some = value.optional {
                    return true
                }
                return false
            }
            .map { $0.forceUnwrap() }
    }
    
}


extension BehaviorRelay where Element == Int {
    
    func reset(to rawValue: Int = 1) {
        accept(rawValue)
    }
    
    func nextPage(offset: Int = 1) {
        accept(value + offset)
    }
    
    func previewPage(offset: Int = 1) {
        if value - offset <= 0 {
            accept(0)
        } else {
            accept(value - offset)
        }
    }
    
}
extension PublishRelay where Element == Void {
    
    /// Call to replace with `accept(())` invoke.
    func acceptAction() {
        accept(())
    }
    
}
