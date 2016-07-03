//
//  TestSwiftFile.swift
//  Guteabsicht
//
//  Created by Andrey Manov on 03/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

import Foundation

class TestSwiftFile: NSObject {
    
    func getTestObjCStringTrhoughSwift() -> String {
        var s = TestObjCFile().getTestStringFromObjC()
        s = s + "Through Swift"
        return s
    }
}