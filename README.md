# iOS Developer Technical Task


## Feature 
1. network status banner
2. load next page when tableView scroll to bottom
3. pull refresh to reload first page
4. using cache request data in Offline mode
5. using protocol to implement dependency injection on database and network service.
6. save favorite event in userDefault 

## Install
require Xcode Version 9.4.1 (9F2000) swift 4.1 iOS11 
1. git clone this repo
2. install pod
```bash
$ pod install
```
3. open LivestyledLite.xcworkspace
4. Select top left "No Scheme", select "New Scheme"
5. Select target "LivestyledLite" and name LivestyledLite, click OK.
6. Select ReachabilitySwift target build setting in Pods project.
7. change Swift Language Version to Swift 4.1
8. open Reachability.swift file in Pods/ReachabilitySwift change line 241 (unlock file)
```
guard let self = self else { return }
```
to 
```
guard let `self` = self else { return }
```
9. cmd + r run the app on Simulator (because it reqiure iOS11). :)


## UnitTest
1. new Scheme "LivestyledLiteTests"
2. cmd + u start test
- check unit test code in LivestyledLiteTests/LivestyledLiteTests.swift

## Architecture
- MVVM + Coordinator

# Development steps
1. Add model test
2. Add network layer, mock network layer for DI.
3. Add ViewModel, test viewModel
4. Add Coordinator, EventsViewController
5. Add tableView.
6. Implement network request.
7. Implement pagination.
8. Add refreshControl, implement refresh function.
9. Add offline error handler.
10. if request fail, return fake data.
11. Add db interface, unit test.
12. Add notification test.
13. Add button set favorite function.

