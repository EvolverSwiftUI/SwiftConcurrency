//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 6/14/22.
//

import SwiftUI
import Combine

class AsyncPublisherDataManager {
//actor AsyncPublisherDataManager {

    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
//        using async/await
        Task {
            await MainActor.run(body: {
                self.dataArray = ["ONE"]
            })

            // here actually streaming into a single pipeline
            for await value in manager.$myData.values {
                await MainActor.run(body: {
                    self.dataArray = value
                })
                break
            }
            
            await MainActor.run(body: {
                self.dataArray = ["TWO"]
            })

        }
        
//        using Combine
//        manager.$myData
//            .receive(on: DispatchQueue.main, options: nil)
//            .sink { data in
//                self.dataArray = data
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }
}


struct AsyncPublisherBootcamp: View {
    
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
