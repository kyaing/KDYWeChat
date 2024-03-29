Table and Collection view data sources
======================================

## Features

- [x] **O(N)** algorithm for calculating differences
  - the algorithm has the assumption that all sections and items are unique so there is no ambiguity
  - in case there is ambiguity, fallbacks automagically on non animated refresh
- [x] it applies additional heuristics to send the least number of commands to sectioned view
  - even though the running time is linear, preferred number of sent commands is usually a lot less then linear
  - it is preferred (and possible) to cap the number of changes to some small number, and in case the number of changes grows towards linear, just do normal reload
- [x] Supports **extending your item and section structures**
  - just extend your item with `IdentifiableType` and `Equatable`, and your section with `AnimatableSectionModelType`
- [x] Supports all combinations of two level hierarchical animations for **both sections and items**
  - Section animations: Insert, Delete, Move
  - Item animations: Insert, Delete, Move, Reload (if old value is not equal to new value)
- [x] Configurable animation types for `Insert`, `Reload` and `Delete` (Automatic, Fade, ...)
- [x] Example app
- [x] Randomized stress tests (example app)
- [x] Supports editing out of the box (example app)
- [x] Works with `UITableView` and `UICollectionView`

## Why
Writing table and collection view data sources is tedious. There is a large number of delegate methods that need to be implemented for the simplest case possible.

RxSwift helps alleviate some of the burden with a simple data binding mechanism:
1) Turn your data into an Observable sequence
2) Bind the data to the tableView/collectionView using one of:
  - `rx_items(dataSource:protocol<RxTableViewDataSourceType, UITableViewDataSource>)`
  - `rx_items(cellIdentifier:String)`
  - `rx_items(cellIdentifier:String:Cell.Type:_:)`
  - `rx_items(_:_:)`

```swift
let dataSource = Observable<[String]>.just(["first element", "second element", "third element"])

dataSource.bindTo(tableView.rx.items(cellIdentifier: "Cell")) { index, model, cell in
  cell.textLabel?.text = model
}
.addDisposableTo(disposeBag)
```

This works well with simple data sets but does not handle cases where you need to bind complex data sets with multiples sections, or when you need to perform animations when adding/modifying/deleting items.  

These are precisely the use cases that RxDataSources helps solve.

With RxDataSources, it is super easy to just write

```swift
Observable.just([MySection(header: "title", items: [1, 2, 3])])
    .bindTo(tableView.rx.items(dataSource: dataSource))
    .addDisposableTo(disposeBag)
```
![RxDataSources example app](https://raw.githubusercontent.com/kzaher/rxswiftcontent/rxdatasources/RxDataSources.gif)

## How
Given the following custom data structure:
```swift
struct CustomData {
  var anInt: Int
  var aString: String
  var aCGPoint: CGPoint
}
```

1) Start by defining your sections with a struct that conforms to the `SectionModelType` protocol:
  - define the `Item` typealias: equal to the type of items that the section will contain
  - declare an `items` property: of type array of `Item`

```swift
struct SectionOfCustomData {
  var header: String    
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = CustomData
  
   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  } 
}
```

2) Create a dataSource object and pass it your `SectionOfCustomData` type:
```swift 
let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>()
```

3) Customize closures on the dataSource as needed:
- `configureCell` (required)
- `titleForHeaderInSection`
- `titleForFooterInSection`
- etc

```swift 
dataSource.configureCell = { ds, tv, ip, item in
  let cell = tv.dequeueReusableCellWithIdentifier("Cell", forIndexPath: ip)
  cell.textLabel?.text = "Item \(item.anInt): \(item.aString) - \(item.aCGPoint.x):\(item.aCGPoint.y)"
  return cell
}
dataSource.titleForHeaderInSection = { ds, index in
  return ds.sectionModels[index].header
}
```

4) Define the actual data as an Observable sequence of CustomData objects and bind it to the tableView
```swift 
let sections = [
  SectionOfCustomData(header: "First section", items: [CustomData(anInt: 0, aString: "zero", aCGPoint: CGPoint.zero), CustomData(anInt: 1, aString: "one", aCGPoint: CGPoint(x: 1, y: 1)) ]),
  SectionOfCustomData(header: "Second section", items: [CustomData(anInt: 2, aString: "two", aCGPoint: CGPoint(x: 2, y: 2)), CustomData(anInt: 3, aString: "three", aCGPoint: CGPoint(x: 3, y: 3)) ])
]

Observable.just(sections)
  .bindTo(tableView.rx.items(dataSource: dataSource))
  .addDisposableTo(disposeBag)
```


### Animations
To implement animations with RxDataSources, the same steps are required as with non-animated data, execept:
- SectionOfCustomData needs to conform to `AnimatableSectionModelType`
- dataSource needs to be an instance of `RxTableViewSectionedAnimatedDataSource` or `RxTableViewSectionedAnimatedDataSource`


## Requirements

Xcode 8.0 beta 6 (8S201h)

For Swift 2.3 version please use versions `0.1 ... 0.9`

## Installation

**We'll try to keep the API as stable as possible, but breaking API changes can occur.**

### CocoaPods

Podfile
```
pod 'RxDataSources', '~> 1.0.0.beta.1'
```

### Carthage

Cartfile
```
github "RxSwiftCommunity/RxDataSources"
```
