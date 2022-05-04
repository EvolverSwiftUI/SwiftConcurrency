//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 5/4/22.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    func fetchImage() async {
        do {
            let url = URL(string: "https://picsum.photos/200")!
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            self.image = UIImage(data: data)
        } catch {
            debugPrint("Error : \(error.localizedDescription)")
        }
    }
    
    func fetchImage2() async {
        do {
            let url = URL(string: "https://picsum.photos/200")!
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            self.image2 = UIImage(data: data)
        } catch {
            debugPrint("Error : \(error.localizedDescription)")
        }
    }

}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack {
            if let img = viewModel.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            if let img2 = viewModel.image2 {
                Image(uiImage: img2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            }

        }
        .onAppear {
            //Task {
            //    debugPrint(Thread.current)
            //    debugPrint(Task.currentPriority)
            //    await viewModel.fetchImage()
            //}
            //Task {
            //    await viewModel.fetchImage()
            //
            //    debugPrint(Thread.current)
            //    debugPrint(Task.currentPriority)
            //    await viewModel.fetchImage2()
            //}
            
            //Task(priority: .high) {
            //    //try? await Task.sleep(nanoseconds: 2_000_000_000) // sleep for 2 seconds
            //    await Task.yield()
            //    debugPrint("high : \(Thread.current) : \(Task.currentPriority)")
            //}
            //Task(priority: .userInitiated) {
            //    debugPrint("userInitiated : \(Thread.current) : \(Task.currentPriority)")
            //}
            //
            //Task(priority: .medium) {
            //    debugPrint("medium : \(Thread.current) : \(Task.currentPriority)")
            //}
            //
            //Task(priority: .low) {
            //    debugPrint("low : \(Thread.current) : \(Task.currentPriority)")
            //}
            //Task(priority: .utility) {
            //    debugPrint("utility : \(Thread.current) : \(Task.currentPriority)")
            //}
            //
            //Task(priority: .background) {
            //    debugPrint("background : \(Thread.current) : \(Task.currentPriority)")
            //}
            
            
            //Task(priority: .utility) {
            //    debugPrint("utility : \(Thread.current) : \(Task.currentPriority)")
            //
            //    //Task {
            //    //    debugPrint("utility2 : \(Thread.current) : \(Task.currentPriority)")
            //    //}
            //
            //    Task.detached {
            //        debugPrint("utility2 : \(Thread.current) : \(Task.currentPriority)")
            //    }
            //
            //}
            
            
            
            

        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
