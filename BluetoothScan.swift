//
//  BluetoothScan.swift
//  TestApp
//
//  Created by Sam on 2022/1/17.
//
import Foundation
import CoreBluetooth
import UIKit
import SwiftUI
//import UIKit


struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
}

struct stopPeripheral: Identifiable{
    let id: String
    let name: String
    let rssi: String
}


class BluetoothScan: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    var myCentral: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var myService = [CBService]()
    var mycharacteristic: CBCharacteristic!
    var characteristicWrite: CBCharacteristic!
    var characteristicRead: CBCharacteristic!
    var characteristicNotify: CBCharacteristic!
    private var SERVICE_UUID = "42421100-5A22-46DD-90F7-7AF26F723159"
    //public static let bleCharacteristicUUID = CBUUID.init(string: "42421100-5A22-46DD-90F7-7AF26F723159")
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var isConnected = false
    @Published var isScanning = false
    @Published var myValue="請連接裝置"
    @Published var i = 0
    
    
    override init() {
        super.init()
        
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
        
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue)
        print(newPeripheral)
        peripherals.append(newPeripheral)
        
        
        if let pname = peripheral.name {
            if pname == "QuickFeather" {
                self.myPeripheral = peripheral
                self.myPeripheral.delegate = self
                //self.myCentral.connect(peripheral, options: nil)
            }
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate=self
        myPeripheral=peripheral
        self.myPeripheral.discoverServices(nil)
        myCentral.stopScan()
        
        peripheralState()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        guard let services = peripheral.services
        else {
            return
        }
        
        for service in services{
            print("Service \(service.uuid)")
            if(service.uuid.uuidString == SERVICE_UUID){
                //self.Label_BLEStatus.text = "Quick AI Test"
                peripheral.discoverCharacteristics(nil, for: service)
            }
            else{
                //print("Not a valid service")
                //self.Label_BLEStatus.text = "Quick AI Test"
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        for characteristic in service.characteristics! {
            if(characteristic.properties.contains(.read) ){
                print("Property contains  read")
                peripheral.readValue(for: characteristic)
                characteristicRead = characteristic
            }
            if(characteristic.properties.contains(.write) ){
                print("Property contains write")
                characteristicWrite = characteristic
            }
            if(characteristic.properties.contains(.notify)){
                peripheral.setNotifyValue(true, for: characteristic)
                characteristicNotify = characteristic
            }
        }
    }
    //Stringvalue[Stringvalue.index(Stringvalue.startIndex, offsetBy: 18)]
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        guard let QuickFeather_Value = characteristic.value else{ return }
        let dataString = String(data: QuickFeather_Value, encoding: String.Encoding.utf8)
        let Stringvalue=String(describing: dataString)
        
        if Stringvalue.count >= 14 {
            let numberValue=Stringvalue[Stringvalue.index(Stringvalue.startIndex, offsetBy: 14)]
            let StringnumberValue=String(describing: numberValue)
            myValue=StringnumberValue
            ///print(myValue)
            //print(numberValue)
            //print(Stringvalue)
            i = Int(myValue) ?? 0
            if(isinit==true){
                if(i == Int(myValue) ?? 0){
                    StatusCount[i]+=1
                }
            }
            if(StatusClear == true){
                StatusCount = [Int](repeating: 0, count: sendArray!.count)
                StatusClear = false
            }
        }
    }
    
    
    
    
    func startScanning() {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
        isScanning=true
    }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
        isScanning=false
    }
    func connectDevice(){
        myCentral.connect(myPeripheral, options: nil)
    }
    func disconnectDevice(){
        self.myCentral.cancelPeripheralConnection(myPeripheral)
        peripheralState()
    }
    func peripheralState(){
        if myPeripheral.state == .connected{
            isConnected=true
        }else{
            isConnected=false
        }
    }
}

