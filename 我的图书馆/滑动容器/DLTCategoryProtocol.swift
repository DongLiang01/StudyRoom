//
//  DLTCategoryProtocol.swift
//  myBook
//
//  Created by dongliang on 2026/1/23.
//

import UIKit

protocol DLTCategoryListContentDelegate: NSObjectProtocol {
    func listView() -> UIView
    func listScrollView() -> UIScrollView?
    func listViewWillAppear()
    func listViewDidAppear()
    func listViewWillDisappear()
    func listViewDidDisappear()
}

extension DLTCategoryListContentDelegate {
    func listViewWillAppear() {
        //do some thing
    }
    
    func listViewDidAppear() {
        //do some thing
    }
    
    func listViewWillDisappear() {
        //do some thing
    }
    
    func listViewDidDisappear() {
        //do some thing
    }
}

protocol DLTCategoryListContainerDelegate: NSObjectProtocol {
    func numberOfListsInlistContainerView() -> Int
    func listContainerViewInitListForIndex(index: Int) -> any DLTCategoryListContentDelegate
}
