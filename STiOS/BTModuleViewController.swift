//
//  BTModuleViewController.swift
//  BTDEMOAPP
//
//  Created by Christian Chabikuli on 2017-01-24.
//  Copyright © 2017 Christian Chabikuli. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class BTModuleViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate  {
    
    //Variable intializations
    
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    fileprivate var centralManager: CBCentralManager?
    fileprivate var isBluetoothEnabled = false
    fileprivate var isConnected = false
    fileprivate var scanTimer: Timer?
    fileprivate var connectionAttemptTimer: Timer?
    fileprivate var connectedPeripheral: CBPeripheral?
    fileprivate var peripheral: CBPeripheral?
    
    // UUID and characteristics
    let BLEModuleServiceUUID = CBUUID(string: "0000dfb0-0000-1000-8000-00805f9b34fb")
    let kBlunoDataCharacteristic  = CBUUID(string: "0000dfb1-0000-1000-8000-00805f9b34fb")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self

        //init CBCentralManager and its delegate
        
        outputLabel.text = "Waiting for device..."
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //We set the cell title according to the peripheral's name
       // let peripheral: CBPeripheral = self.peripheral!
        cell.textLabel?.text = "hello"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isBluetoothEnabled){
            let peripheral: CBPeripheral = self.peripheral!
        centralManager?.connect(peripheral, options: nil)
        // Connect to peripheral
        outputLabel.text = "Bluno Board is now connected"
        }
        
    }
    
    
    func timeout()
    {
        //outputLabel.text = "Connection attempt timed out..."
        if let connectedPeripheral = connectedPeripheral
        {
            centralManager?.cancelPeripheralConnection(connectedPeripheral)
        }
        connectionAttemptTimer?.invalidate()
        scanTimer?.invalidate()
        outputLabel.text = "Make sure the device is ON"
    }
    
    
    func startScanning()
    {
        
        if let central = centralManager
        {
            central.scanForPeripherals(withServices: [BLEModuleServiceUUID], options: nil)
            outputLabel.text = "Scanning..."
            scanTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(BTModuleViewController.timeout), userInfo: nil, repeats: false)
        }
        //output.text = "Device is already connected"
        
    }
    
    func stopScanning()
    {
        print("Stopped scanning.")
        //print("Found \(visiblePeripherals.count) peripherals.")
        centralManager?.stopScan()
        //refreshControl?.endRefreshing()
        scanTimer?.invalidate()
        outputLabel.text = "Make sure the device is ON"
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Be sure to retain the peripheral or it will fail during connection.
        
        // Validate peripheral information
        if ((peripheral.name == nil) || (peripheral.name == "")) {
            return
        }
        
        // If not already connected to a peripheral, then connect to this one
        if ((self.peripheral == nil) || (self.peripheral?.state == CBPeripheralState.disconnected))
        {
            // Retain the peripheral before trying to connect
            self.peripheral = peripheral
            isBluetoothEnabled = true
            

            //central.connect(peripheral, options: nil)
            outputLabel.text = "Found " + peripheral.name! + " device"
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        // Create new service class
        if (peripheral == self.peripheral) {
            peripheral.delegate = self
            peripheral.discoverServices(nil)
            //print("Connected")
            isConnected = true
            
        }
        
        central.stopScan()
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        // See if it was our peripheral that disconnected
        //if (peripheral == self.peripheralBLE) {
        //self.bleService = nil;
        peripheral.delegate = nil
        print("Bluno Board is disconnected")
        //outputLabel.text = "Bluno Board is disconnected"
        //}
        
        // Start scanning for new devices
        self.startScanning()
    }
    
    // MARK: - Private
    
    func clearDevices() {
        //self.bleService = nil
        self.peripheral = nil
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            NSLog("BLE PoweredOff")
            self.clearDevices()
            
        case .unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            NSLog("BLE Unauthorized")
            break
            
        case .unknown:
            // Wait for another event
            break
            
        case .poweredOn:
            NSLog("BLE poweredOn")
            
        case .resetting:
            self.clearDevices()
            
        case .unsupported:
            break
            
        }
    }
    
    // Mark: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let uuidsForBTService: [CBUUID] = [kBlunoDataCharacteristic ]
        
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            // No Services
            return
        }
        
        for service in peripheral.services! {
            if service.uuid == BLEModuleServiceUUID {
                peripheral.discoverCharacteristics(uuidsForBTService, for: service)
                NSLog("Discovered service: %@",service);
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == kBlunoDataCharacteristic {
                    // self.positionCharacteristic = (characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                    // Send notification that Bluetooth is connected and all required characteristics are discovered
                   // self.sendBTServiceNotificationWithIsBluetoothConnected(true)
                    NSLog("Discovered characteristic: %@", characteristic)
                    
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        
        //var data: String
        
        if characteristic.uuid == kBlunoDataCharacteristic {
            let value = String(data: characteristic.value!, encoding: String.Encoding.utf8)
            //print("Value \(value)")
            for char in (value?.characters)!{
                if (char >= "0" && char >= "9"){
                    print("value \(value)")
                }
                
            }
            
        }
        
    }
    
    
    
    // Mark: - Private
    
    func readData(data: Float) ->[Float]
    {
        var value = [Float]()
        /******** (1) CODE TO BE ADDED *******/
        for index in 0...4{
            value[index] = data
        }
        return value
    }
    
    /*func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }*/
    

    @IBAction func scanBTN(_ sender: Any) {
        let central = centralManager
        if (central?.state == .poweredOn && !isConnected)
        {
            self.startScanning()
        }
            
    }
    
    
}
