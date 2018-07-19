//
//  DemoModel.swift
//  CoreBluetoothDemo-Swift
//
//  Created by 陈煜彬 on 2018/7/18.
//  Copyright © 2018年 陈煜彬. All rights reserved.
//

import UIKit
import CoreBluetooth

class DemoModel: NSObject {

    
    var peripheral : CBPeripheral?
    var advertisementData : NSDictionary?
    var RSSI : NSNumber?
    
}
