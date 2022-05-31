//
//  SendableBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 5/31/22.
//

import SwiftUI

actor CurrentUserManager {
    
//    func updateDatabase(userInfo: MyUserinfo) {
    func updateDatabase(userInfo: MyClassUserInfo) {

    }
}

struct MyUserinfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
//        let info = MyUserinfo(name: "USER INFO")
        let info = MyClassUserInfo(name: "USER INFO")
        await manager.updateDatabase(userInfo: info)
    }
 }

struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
