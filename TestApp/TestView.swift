//
//  TestView.swift
//  TestApp
//
//  Created by Sam on 2022/1/5.
//

import SwiftUI
import CoreBluetooth
import Foundation
import UIKit

struct TestView: View {
    @ObservedObject var bluetoothScan = BluetoothScan()

    var myPeripheral: CBPeripheral!
    @State var value: String=""
    @State private var name = ""
    var body: some View {
        //設定頁面背景色
        ZStack{
            Color("backgroundcolor")
                .ignoresSafeArea()//無視手機圓角區域
            //背景改為圖片
            //            Image("ha")
            //                   .resizable()
            //                   .scaledToFill()
            //                   .frame(minWidth: 0,  maxWidth: .infinity, minHeight: 0,  maxHeight: .infinity)
            //                   .ignoresSafeArea()
            // 滾輪
            ScrollView{
                VStack{
                    HStack{
                        Text(verbatim:"TestApp")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.red)
                            .padding(10)
                        Spacer()
                    }
                    //自訂分隔線條
                    Rectangle()
                        .fill(.red)
                        .frame(height: 5)
                        .edgesIgnoringSafeArea(.horizontal)
                    
                    /*裝置名稱、MAC位址、連接狀態*/
                    VStack(alignment: .leading) {

                        Text("Name").font(.headline)
                            .foregroundColor(.red)
                        
                        Text("裝置設備名稱")
                            .font(.headline)
                            .padding()
                        //文字邊框設計
                            .frame(width: 350, height: 40, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))//設定圓角邊框及邊色線寬


//                        Text("Address").font(.headline)
//                            .foregroundColor(.red)
//                        Text("裝置設備位址")
//                            .font(.headline)
//                            .padding()
//                        //文字邊框設計
//                            .frame(width: 350, height: 40, alignment: .leading)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))//設定圓角邊框及邊色線寬
//

                        Text("Status").font(.headline)
                            .foregroundColor(.red)
                        
//                        Text("與裝置連接狀態：")
//                            .font(.headline)
//
//                        if bluetoothScan.isConnected{
//                            HStack{
//                                Image(systemName: "checkmark.circle")
//                                    .foregroundColor(.green)
//                                Text("已連接！")
//                                    .foregroundColor(.green)
//                            }
//                            
//                        }else{
//                            HStack{
//                                Image(systemName: "multiply.circle")
//                                    .foregroundColor(.red)
//                                Text("未連接！")
//                                    .foregroundColor(.red)
//                            }
//                        }
                        
                        Text("裝置設備連接狀態")
                            .font(.headline)
                            .padding()
                        //文字邊框設計
                            .frame(width: 350, height: 40, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))//設定圓角邊框及邊色線寬
                    }
                    //按鈕
//                    HStack{
//                        Button(action: {self.bluetoothScan.disconnectDevice()}){
//                            HStack{
//                                Image(systemName: "xmark.circle")
//                                //.font(.title)
//                                Text("disconnect")
//                                    .fontWeight(.semibold)
//                                //.font(.title)
//                            }
//                            .padding(10)
//                            .foregroundColor(.white)
//                            .background(Color.red)
//                            .cornerRadius(10)
//                            .frame(width: 150, height: 70)
//                        }
//                        Button(action: {}){
//                            HStack{
//                                Image(systemName: "trash")
//                                //.font(.title)
//                                Text("forget")
//                                    .fontWeight(.semibold)
//                                //.font(.title)
//                            }
//                            .padding(10)
//                            .foregroundColor(.white)
//                            .background(Color.red)
//                            .cornerRadius(10)
//                            .frame(width: 150, height: 70)
//                        }
//                    }
                    /*顯示機台狀態*/
                    Text("當前狀態")
                        .font(.title)
                        .foregroundColor(.red)
                    VStack{
                        //TextField("1",text: $value)
                        Text(self.bluetoothScan.myValue)
                            .font(.system(size: 50))
                            .fontWeight(.heavy)
                        Text("background")
                            .font(.system(size: 50))
                            .fontWeight(.heavy)
                    }
                    .frame(width: 350, height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))//設定圓角邊框及邊色線寬
                    Spacer()
                }
            }
        }
    }
    struct TestView_Previews: PreviewProvider {
        static var previews: some View {
            TestView()
        }
    }
}
