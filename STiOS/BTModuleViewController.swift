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
    fileprivate var isConnected = false
    fileprivate var scanTimer: Timer?
    fileprivate var connectionAttemptTimer: Timer?
    fileprivate var connectedPeripheral: CBPeripheral?
    fileprivate var peripherals: [CBPeripheral?] = []
    fileprivate var peripheral: CBPeripheral?
    
    // variables for sensor updates
    var formatString = ""
    var strArr = [String]()
    var writingToString = false
    var sensor0Received = false, sensor1Received = false, sensor2Received = false, sensor3Received = false // sensor update flags
    var sensorValues = [String: Float]()
    
    // UUID and characteristics
    let BLEModuleServiceUUID = CBUUID(string: "0000dfb0-0000-1000-8000-00805f9b34fb")
    let kBlunoDataCharacteristic  = CBUUID(string: "0000dfb1-0000-1000-8000-00805f9b34fb")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self

        //init CBCentralManager and its delegate
        
        outputLabel.text = "Make sure the device is ON"
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
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //We set the cell title according to the peripheral's name
        let peripheral: CBPeripheral = self.peripherals[indexPath.row]!
        
        if (!isConnected)
        {
            cell.textLabel?.text = peripheral.name
        }
        else
        {
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral: CBPeripheral = self.peripherals[indexPath.row]!
        
        if (!isConnected)
        {
            centralManager?.connect(peripheral, options: nil)
            // Connect to peripheral
            
            outputLabel.text = "Bluno Board is now connected"

        }

    }
    
    
    func connectionTimeout()
    {
        //outputLabel.text = "Connection attempt timed out..."
        if let connectedPeripheral = connectedPeripheral
        {
            centralManager?.cancelPeripheralConnection(connectedPeripheral)
        }

        connectionAttemptTimer?.invalidate()
    }
    
    
    func startScanning()
    {
        
        if let central = centralManager
        {
            // reset peripheral list
            peripherals = []
            self.tableView.reloadData()
            central.scanForPeripherals(withServices: [BLEModuleServiceUUID], options: nil)
            outputLabel.text = "Scanning..."
            print("scanning...")
            scanTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(stopScanning), userInfo: nil, repeats: false)
        }
        
    }
    
    func stopScanning()
    {
        outputLabel.text = ""
        centralManager?.stopScan()
        scanTimer?.invalidate()
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
            

            //central.connect(peripheral, options: nil)
            outputLabel.text = ""
            
            peripherals.append(peripheral)
            self.tableView.reloadData()
            
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
        
        self.peripherals = []
        self.tableView.reloadData()
        isConnected = false
        peripheral.delegate = nil
        print("Bluno Board is disconnected")
        outputLabel.text = "Bluno Board is disconnected"
        
        
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
        
        if characteristic.uuid == kBlunoDataCharacteristic {
            let value = String(data: characteristic.value!, encoding: String.Encoding.utf8)
            assembleFormatString(value!)
        }
        
    }
    
    
    
    // Mark: - Private
    
    func assembleFormatString(_ data: String){
        // parse stream
        for char in data.characters
        {
            // check for start of formatted stream
            if (char == "/")
            {
                writingToString = true
            }
            
            // check for end of formatted stream
            else if (char == "~")
            {
                writingToString = false
                updateSensorDictionary(sensor_str: formatString)
                formatString = ""
            }
            
            else
            {
                if (writingToString)
                {
                    formatString.append(char)
                }
            }
        }
        
    }
    
    func updateSensorDictionary(sensor_str: String)
    {
        print(sensor_str)
        // split formatted string by delimiters
        let strArr = sensor_str.components(separatedBy: ",")
 
        // store sensor components
        sensorValues[strArr[0]+"w"] = (strArr[1] as NSString).floatValue;
        sensorValues[strArr[0]+"x"] = (strArr[2] as NSString).floatValue;
        sensorValues[strArr[0]+"y"] = (strArr[3] as NSString).floatValue;
        sensorValues[strArr[0]+"z"] = (strArr[4] as NSString).floatValue;
        
        // set sensor flags
        if (strArr[0] == "s0")
        {
            sensor0Received = true
        }
        
        else if (strArr[0] == "s1")
        {
            sensor1Received = true
        }
        
        else if (strArr[0] == "s2")
        {
            sensor2Received = true
        }
        
        else if (strArr[0] == "s3")
        {
            sensor3Received = true
        }
        
        if (sensor0Received && sensor1Received && sensor2Received && sensor3Received)
        {
            // access tab-shared variables
            if let tbs = self.tabBarController as? SessionTabBarController
            {
                tbs.userSkeleton.updateFromSensors(sensorData: sensorValues)
                tbs.currentExercise?.updateDelegates()
            }
            
            // reset flags
            sensor0Received = false
            sensor1Received = false
            sensor2Received = false
            sensor3Received = false
        }
    }
    
    /*func convertToFloat(_ array: [String]){
        
        var floatArr = [Float]()
        var arrIndex = 0
        
        for string in array {
            //print("string is \(string)")
            let myFloat = (string as NSString).floatValue
            //numberFloatValue = Double(number.floatValue)
            
            floatArr.insert(myFloat, at: arrIndex)
            
            print("float[\(arrIndex)] is \(floatArr[arrIndex])")
            arrIndex += 1
            
        }
        resetArray()
        
        //return floatArr
    } */
    
    /*func resetArray(){
        self.strArr = []
    } */

    @IBAction func scanBTN(_ sender: Any) {
        let central = centralManager
        if (central?.state == .poweredOn && !isConnected)
        {
            self.startScanning()
            
        }
            
    }
    
    
}
