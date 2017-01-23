//: Playground - noun: a place where people can play

import UIKit
import RxSwift

var str = "Hello, playground"

let disposeBag = DisposeBag()

let sequenceInt = Observable.of(1, 2, 3)
let sequenceString = Observable.of("A", "B", "C", "-")

sequenceInt
    .flatMap { (x: Int) -> Observable<String>  in
        print("from sequenceInt \(x)")
        return sequenceString
    }
    .subscribe {
        print($0)
    }
    .addDisposableTo(disposeBag)