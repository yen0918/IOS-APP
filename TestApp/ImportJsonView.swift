//
//  ImportJsonView.swift
//  TestApp
//
//  Created by Sam on 2022/1/5.
//

import SwiftUI

class myarray: ObservableObject {
    @Published var valueArray = [""]
    @Published var edittext = ""
    @Published var isempty = true
    
    
    
    func showList(){
        let x = edittext.replacingOccurrences(of: "\"ClassMaps\": {", with: "0 : Unknown\n")
        let y = x.replacingOccurrences(of: "}", with: "")
        //print(y)
        let z = y.replacingOccurrences(of: ", ", with: "\n")
        //print(z)
        let a = z.replacingOccurrences(of: ":", with: " : ")
        let b = a.replacingOccurrences(of: "\"", with: "")
        valueArray = b.components(separatedBy: "\n")
        valueArray.removeLast()
        
        sendArray = valueArray
    }
}

public var sendArray : [String]? //宣告一個能儲存並傳送已變化之值的變數
public var isinit = false


struct ImportJsonView: View {
    @StateObject var Myarray = myarray()
    
    //Json檔值
    @State var Json = ""
    @State private var showAlert = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {

        //設定頁面背景色
        
        ZStack{
            Color("backgroundcolor")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                
                /*-----------------------標題--------------------------*/
                HStack{
                    
                    Text(verbatim:"設置狀態名稱")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(10)
                }
                /*----------------------分隔線-------------------------*/
                
//                Rectangle()
//                    .fill(.red)
//                    .frame(height: 5)
//                    .edgesIgnoringSafeArea(.horizontal)
                //                    /*-----------------------功能介紹--------------------------*/
                //輸入Json的TextEditorEnter your Json file...
                ZStack(alignment: .leading){
                    CustomTextEditor.init(placeholder: "Enter your Json txt...\nExample:\n\"ClassMaps\": {\"1\": \"XXX\", \"2\": \"XXX\", \"3\": \"XXX\", \"0\": \"Unknown\"}", text: $Json)
                        .font(.body)
                        .foregroundColor(Color("importTextColor"))
                        .background(Color("import_entry"))
                        .accentColor(Color("importTextColor"))
                        .frame(height: 150)
                        .cornerRadius(8)
                        .keyboardType(.default)
                }
                .padding(.horizontal)
                
                //文字說明
                Text("輸入Json格式文字，點擊送出後將產生狀態名稱列表")
                    .font(.headline)
                    .padding(.horizontal)
                
                
                //確認按鈕
                
                
                HStack{
                    Button{
                        if Json.prefix(11) == "\"ClassMaps\""{
                            UIApplication.shared.endEditing()
                            Myarray.edittext = Json
                            //print(Myarray.sendmyarray)
                            Myarray.showList()
                            Myarray.isempty = false
                            isinit = true
                            
//                            let x = Json.replacingOccurrences(of: "\"ClassMaps\": {", with: "")
//                            let y = x.replacingOccurrences(of: "}", with: "")
//                            let z = y.replacingOccurrences(of: ", ", with: "\n")
//                            let a = z.replacingOccurrences(of: ":", with: "")
//                            let b = a.replacingOccurrences(of: "\"", with: "")
//                            Myarray.valueArray = b.components(separatedBy: "\n")
                            Json = ""
                        }else{
                            showAlert=true
                            Json=""
                            UIApplication.shared.endEditing()
                        }
                    } label:{
                        HStack{
                            Image(systemName: "paperplane.fill")
                            Text("送出")
                        }
                        .frame(width: 100, height: 50, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))
                        .padding()
                    }.alert(isPresented: $showAlert) { () -> Alert in
                        let answer = "請輸入正確內容！"
                        return Alert(title: Text(answer))
                     }
                    
                    Button{
                        UIApplication.shared.endEditing()
                    }label: {
                        HStack{
                        Image(systemName: "keyboard.chevron.compact.down")
                            Text("隱藏鍵盤")
                        }
                    }
                    .frame(width: 150, height: 50, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 3))
                    .padding()
                }.padding(5)
                //Text(xd)
                
                /*----------------------分隔線-------------------------*/
                Rectangle()
                    .fill(.red)
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                
//                Text(verbatim:"狀態名稱")
//                    .font(.largeTitle)
//                    .fontWeight(.heavy)
//                    .foregroundColor(.red)
//                    .padding(10)
                /*----------------------狀態名稱List-------------------------*/
                if Myarray.isempty == false{
                    List(Myarray.valueArray, id: \.self){
                        Text("Class \($0)")
                            .font(.title)
                            .lineSpacing(30)
                    }
                    .onAppear {
                        if colorScheme == .dark{
                            UITableView.appearance().backgroundColor = .black
                        }else{
                            UITableView.appearance().backgroundColor = .white
                        }
                        //背景設白色

                        //分隔線紅色
                        UITableView.appearance().separatorColor = .red
                    }
                }
                
                Spacer()
            }
        }
    }
    /*-----------------------自定義TextEditor格式--------------------------*/
    struct CustomTextEditor: View {
        let placeholder: String
        @Binding var text: String
        let internalPadding: CGFloat = 5
        var body: some View {
            ZStack(alignment: .topLeading) {
                if text.isEmpty  {
                    Text(placeholder)
                        .foregroundColor(Color.primary.opacity(0.25))
                        .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                        .padding(internalPadding)
                }
                TextEditor(text: $text)
                    .padding(internalPadding)
            }.onAppear() {
                UITextView.appearance().backgroundColor = .clear
            }.onDisappear() {
                UITextView.appearance().backgroundColor = nil
            }
        }
    }
    
}
struct ImportJsonView_Previews: PreviewProvider {
    static var previews: some View {
        ImportJsonView()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


