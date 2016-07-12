//
//  ViewController.swift
//  MOConf2016Practice
//
//  Created by Igor Vasilenko on 24/06/16.
//  Copyright © 2016 Igor Vasilenko. All rights reserved.
//

import UIKit
import ReactiveCocoa
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Create signal
        let someSignal = Signal<Int, NSError>{ (observer) -> Disposable? in
            for intValue in 0...5 {
                observer.sendNext(intValue)
            }
            return SimpleDisposable()
        }
        
        /// map ///
        someSignal.map { (intValue) -> String in
            return "value: \(intValue)"
        }.observeNext { (strinValue) in
            
        }
        
        /// filter ///
        someSignal.filter { (intValue) -> Bool in
            return intValue > 0
        }.observeNext { (intValue) in
            
        }
        
        /// take ///
        someSignal.take(1).observeNext { (intValue) in
            // Next event will be once recieved
        }
        
        /// throttle ///
        someSignal.throttle(30, onScheduler: QueueScheduler.mainQueueScheduler).observeNext { (intValue) in
            
        }
        
        /// combineLatest ///
        let (numbersSignal, numbersObserver) = Signal<Int, NSError>.pipe()
        let (lettersSignal, lettersObserver) = Signal<String, NSError>.pipe()
        let combineSignals = combineLatest(numbersSignal, lettersSignal)
            .on { (intValue, stringValue) in
            print(intValue)
            print(stringValue)
        }
        
        /// reduce ///
        combineSignals.reduce("", { (startValue, valuesTuple) in
            let intValue = valuesTuple.0
            let stringValue = valuesTuple.1
            return "\(intValue) \(stringValue)"
        }).observeNext { (stringValue) in
            print(stringValue)
        }
        
        numbersObserver.sendNext(2)
        lettersObserver.sendNext("LOL")
        numbersObserver.sendCompleted()
        lettersObserver.sendCompleted()
        
        /// Producer ///
        let producer = SignalProducer <String, NSError> {(observer, disposable) in
            /// some task (api request, saving to database, etc.)
        }
        
        producer.on(started: {
            /// Some work
            }, event: { (event) in
                /// Some work
        })
        
        /// Mutable Property ///
        var bankAccountBalance = MutableProperty<Double>(100)
        bankAccountBalance.value = 200;
        bankAccountBalance.signal.observeNext { (value) in
            
        }
        
        /// Schedulers ///
        someSignal.observeOn(UIScheduler()).observeNext { (value) in
            /// observer on Main Thread
        }
        
        ///
        let observable = Observable <String>.just("Say hello RxSwift")
        
    }
}

