//
//  ContentView.swift
//  TestApp
//
//  Created by Sam on 2022/1/5.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothScan = BluetoothScan()
    //綁定開啟app時之首頁
    @State var tabViewSelection = 0
    //@Binding var value: String
    var body: some View {
        VStack {
            //綁定開啟app時之首頁為tag:0
            TabView(selection: $tabViewSelection){
                
                /*-----------------------藍芽--------------------------*/
                //tabview畫面
                BluetoothView()
                //標籤
                    .tabItem{
                        Image(systemName: "house")
                        Text("主頁")
                    }
                    .accentColor(.red)//選中標籤顏色
                    .navigationTitle("BluetoothScan")
                    .tag(0)//標籤代號
                /*-----------------------藍芽--------------------------*/
                
                
                /*-----------------------主頁--------------------------*/
//                TestView()//主頁swiftUI檔
//                    .tabItem{
//                        Image(systemName: "house")
//                        Text("主頁")
//                    }
//                    .accentColor(.orange)
//                    .navigationTitle("TestApp")
//                    .tag(0)
                /*-----------------------主頁--------------------------*/
                
                /*-----------------------匯入--------------------------*/
                ImportJsonView()
                    .tabItem{
                        Image(systemName: "square.and.arrow.down")
                        Text("匯入")
                    }
                    .accentColor(.red)
                    .navigationTitle("ImportJSON")
                    .tag(1)
            }
            /*-----------------------匯入--------------------------*/
            //tabview樣式，無標籤可滑動
            //.tabViewStyle(PageTabViewStyle())
            //tabview樣式，默認，有標籤
            //.tabViewStyle(DefaultTabViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
