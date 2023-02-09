//
//  CustomTableViewDelegate.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit
public protocol CustomTableDataSource {
    func numberOfRows() -> Int
    func heightForRow() -> CGFloat
}
public protocol CustomTableDelegate {
    func numberOfItemAtIndex<T>(index:Int) -> T
}
class CustomTableView: NSObject {
    var  dataSource:CustomTableDataSource!
    var  delegate:CustomTableDelegate!

}
