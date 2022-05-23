//
//  ActorsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 5/23/22.
//

import SwiftUI

// 1. What is the problems that Actors are solving?

// Ans:
// Data race problem.
// - meaning accessing same object by different threads at a time in the memory.

// 2. How was this problem solved prior to Actors?
// Ans:
// Using Dispatch Queue Serial, we can make classes are thread safe as below example

// 3. Actors can solve the problem!


class MyDataManager {
    
    static let instance = MyDataManager()
    private init() { }
    
    var data: [String] = []
    
    // private let queue = DispatchQueue(label: "com.myApp.MyDataManager")
    // simply called queue as lock
    // here every function call will go in queue order only
    // meaning will go one by one here
    private let lock = DispatchQueue(label: "com.myApp.MyDataManager")

    //func getRandomData() -> String? {
    //    self.data.append(UUID().uuidString)
    //    print("Current Thread", Thread.current)
    //    return self.data.randomElement()
    //}
    
    // same above function
    // write in thread safe way
    func getRandomData(completionHandler: @escaping (_ title: String?) -> Void) {
        lock.async { //bunch of funcs reach here, will get inline manner
            self.data.append(UUID().uuidString)
            print("Current Thread", Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() { }
    
    var data: [String] = []
    
    // thread safe property
    nonisolated let myRandomText = "egergegeg fwewgwegweg wegwegweg"

    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print("Current Thread", Thread.current)
        return self.data.randomElement()
    }
    
    // here we are removing this functions
    // from thread safe environment while calling them
    nonisolated func getNewData() -> String {
        return "NEW DATA!"
    }
}

struct HomeView: View {
    
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
//    let manager = MyDataManager.instance
    let manager = MyActorDataManager.instance

    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear(perform: {
            let _ = manager.getNewData()
            let _ = manager.myRandomText
        })
        .onReceive(timer) { _ in
            //DispatchQueue.global(qos: .background).async {
            //    if let data = manager.getRandomData() {
            //        DispatchQueue.main.async {
            //            self.text = data
            //        }
            //    }
            //}
            
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    if let title = title {
//                        DispatchQueue.main.async {
//                            self.text = title
//                        }
//                    }
//                }
//            }
            
            Task { // Switching to background thread
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: { // Switching to main thread
                        self.text = data
                    })
                }
            }
        }
    }
}

struct BrowseView: View {
    
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    //    let manager = MyDataManager.instance
        let manager = MyActorDataManager.instance

    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            //DispatchQueue.global(qos: .default).async {
            //    if let data = manager.getRandomData() {
            //        DispatchQueue.main.async {
            //            self.text = data
            //        }
            //    }
            //}
            
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let title = title {
//                        DispatchQueue.main.async {
//                            self.text = title
//                        }
//                    }
//                }
//            }

            Task { // Switching to background thread
                if let data = await manager.getRandomData() {
                    await MainActor.run(body: { // Switching to main thread
                        self.text = data
                    })
                }
            }

        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ActorsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorsBootcamp()
    }
}
