import SwiftUI
import CoreBluetooth

struct StaticButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration)->some View{
        configuration.label
    }
}

public var StatusCount = [Int](repeating: 0, count: sendArray!.count)
public var StatusClear = false

struct BluetoothView: View {
    @StateObject var bluetoothScan = BluetoothScan()
    @StateObject var Myarray = myarray()
    
    @State private var stopscanDisabled = true//定義停止掃描鈕未啟用
    @State private var startscanDisabled = false//定義開始掃描鈕已啟用
    @State private var disconnectDisabled = true//定義斷開連接鈕未啟用
    @Environment(\.colorScheme) var colorScheme
    
    
    
    var myPeripheral: CBPeripheral!
    
    var body: some View {
        ScrollView{
            VStack (spacing: 10) {
                
                Text("當前狀態")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack{
                    //TextField("1",text: $value)
                    Text(self.bluetoothScan.myValue)
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                    if (isinit == true){
                        if(Int(self.bluetoothScan.myValue) == bluetoothScan.i){
                            Text(sendArray![bluetoothScan.i].dropFirst(4))
                                .font(.system(size: 50))
                                .fontWeight(.heavy)
                        }
                    }
                }
                .padding()
                .frame(width: 350, height: 150)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))//設定圓角邊框及邊色線寬
                
                if(isinit==true){
                    HStack{
                        
                        
                        
                        Text("狀態統計")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        Spacer()
                        
                        Button(action:{
//                            DispatchQueue.main.async{
//                                StatusCount = [Int](repeating: 0, count: sendArray!.count)
//
//                            }
                            StatusClear = true
                            
                            
                        }){
                            Text("清除")
                                .frame(width: 80, height: 50, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))
                               
                        }.padding()
                        
                    }
                    List{
                        ForEach(0..<sendArray!.count){ i in
                            HStack{
                                Text(sendArray![i])
                                    .font(.title)
                                Spacer()
                                Text("Total: \(StatusCount[i])")
                                    .font(.system(size: 20))
                                //.multilineTextAlignment(.trailing)
                                
                            }
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))//設定圓角邊框及邊色線寬
                    .frame(width: 350,height: 300)
                    
                }
                
                
                
                
                //判斷是否正在掃描 變更View
                if bluetoothScan.isScanning{
                    Text("藍芽裝置")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .center)
                    List(bluetoothScan.peripherals) { peripheral in
                        HStack {
                            Text(peripheral.name)
                            Spacer()
                            Text(String(peripheral.rssi))
                        }
                    }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))//設定圓角邊框及邊色線寬
                        .frame(width: 350,height: 300)
                    //使整條都能點擊
                        .contentShape(Rectangle())
                    //點擊code
                        .onTapGesture {
                            self.bluetoothScan.connectDevice()
                            disconnectDisabled = false
                            stopscanDisabled = true
                            self.bluetoothScan.stopScanning()
                            bluetoothScan.peripherals.removeAll()//清除List
                            
                        }
                }
                
                HStack{
                    Text("藍芽是否開啟：")
                        .font(.headline)
                    
                    // Status goes here
                    if bluetoothScan.isSwitchedOn {
                        Text("手機藍芽已開啟！")
                            .foregroundColor(.green)
                        
                    }
                    else {
                        Text("手機藍芽未開啟！")
                            .foregroundColor(.red)
                    }
                }
                
                HStack{
                    Text("與裝置連接狀態：")
                        .font(.headline)
                    
                    if bluetoothScan.isConnected{
                        HStack{
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                            Text("已連接！")
                                .foregroundColor(.green)
                        }
                        
                    }else{
                        HStack{
                            Image(systemName: "multiply.circle")
                                .foregroundColor(.red)
                            Text("未連接！")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                HStack {
                    VStack (spacing: 10) {
                        Button(action: {
                            self.bluetoothScan.startScanning()
                            print("Start Scanning")
                            stopscanDisabled = false
                            startscanDisabled = true
                        }) {
                            Text("開始掃描")
                                .frame(width: 100, height: 50, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))
                        }.disabled(startscanDisabled)
                        
                        Button(action: {
                            self.bluetoothScan.stopScanning()
                            print("Stop Scanning")
                            stopscanDisabled = true
                            startscanDisabled = false
                            bluetoothScan.peripherals.removeAll()//清除List
                        }) {
                            Text("停止掃描")
                                .frame(width: 100, height: 50, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))
                        }.disabled(stopscanDisabled)
                    }.padding()
                    
                    
                    VStack (spacing: 10) {
                        Button(action: {
                            self.bluetoothScan.disconnectDevice()
                            print("Disconnect Device")
                            disconnectDisabled = true
                            startscanDisabled = false
                            bluetoothScan.myValue="請連接裝置"
                            StatusCount = [Int](repeating: 0, count: sendArray!.count)
                        }) {
                            Text("斷開裝置連接")
                                .frame(width:   150, height: 50, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))
                        }.disabled(disconnectDisabled)
                        Button(action: {
                            
                        }){
                            Text("")
                                .frame(width:   150, height: 50, alignment: .center)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))
                                .opacity(0)
                        }
                    }.padding()
                }
            }
        }
    }
}

struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView()
    }
}

