//
//  DemoViewController.swift
//  CoreBluetoothDemo-Swift
//
//  Created by 陈煜彬 on 2018/7/18.
//  Copyright © 2018年 陈煜彬. All rights reserved.
//

import UIKit
import CoreBluetooth

class DemoViewController: UIViewController {
    
    private var tableView : UITableView!
    private var timer:Timer!
    
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    
    private var sortArray: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        
    }
    
    func setupUI() {
        
        sortArray.removeAllObjects()
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        centralManager = CBCentralManager.init(delegate: self, queue: .main)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


// MARK: - ManagerDelegate, PeripheralDelegate
extension DemoViewController : CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("CBCentralManagerStateUnknown")
        case .resetting:
            print("CBCentralManagerStateResetting")
        case .unsupported:
            print("CBCentralManagerStateUnsupported")
        case .unauthorized:
            print("CBCentralManagerStateUnauthorized")
        case .poweredOff:
            print("CBCentralManagerStatePoweredOff")
        case .poweredOn:
            print("CBCentralManagerStatePoweredOn")
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }
        
        
    }
    
    
    // 搜索蓝牙
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let model = DemoModel.init()
        model.peripheral = peripheral
        model.RSSI = RSSI
        model.advertisementData = advertisementData as NSDictionary
        
        self.sortArray.add(model)
        self.tableView.reloadData()
        
    }
    
    
    //连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        connectedPeripheral = peripheral
        peripheral .discoverServices(nil)
        
        peripheral.delegate = self
        self.title = peripheral.name
        centralManager? .stopScan()
        
        let alertController = UIAlertController.init(title: "已连接上 \(String(describing: peripheral.name))", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "知道了", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        print("连接到名字为 \(String(describing: peripheral.name)) 的设备失败，原因是 \(String(describing: error?.localizedDescription))")
        
        let alertController = UIAlertController.init(title: "连接到名字为 \(String(describing: peripheral.name)) 的设备失败，原因是 \(String(describing: error?.localizedDescription))", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "知道了", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    //连接断开
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("连接到名字为 \(String(describing: peripheral.name)) 的设备断开，原因是 \(String(describing: error?.localizedDescription))")
        
        
        let alertController = UIAlertController.init(title: "连接到名字为 \(String(describing: peripheral.name)) 的设备断开，原因是 \(String(describing: error?.localizedDescription))", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "知道了", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}


// MARK: - TableViewDelegate, DataSource
extension DemoViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = sortArray[indexPath.row] as! DemoModel
        self.centralManager?.connect(model.peripheral!, options: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "DemoCell"
        
        let cell = DemoCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        
        let model = self.sortArray[indexPath.row] as! DemoModel
        
        if model.peripheral?.name == nil || model.peripheral?.name == ""{
            cell.titleLab.text = "未知设备"
        }else {
            cell.titleLab.text = model.peripheral?.name
        }
        
        cell.signalLab.text = NSNumber(integerLiteral: model.RSSI as! Int).stringValue
        
        switch labs((model.RSSI?.intValue)!) {
        case 0...40:
            cell.signalImageView.image = UIImage(named: "信号-4")
        case 41...53:
            cell.signalImageView.image = UIImage(named: "信号-3")
        case 54...65:
            cell.signalImageView.image = UIImage(named: "信号-2")
        case 66...77:
            cell.signalImageView.image = UIImage(named: "信号-1")
        case 77...89:
            cell.signalImageView.image = UIImage(named: "信号-0")
        default:
            cell.signalImageView.image = UIImage(named: "信号-0")
        }
        
        return cell
    }
    
    
}
