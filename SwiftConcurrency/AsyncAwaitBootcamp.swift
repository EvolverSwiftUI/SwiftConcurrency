//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 5/3/22.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
//    func addTitle1() {
//        self.dataArray.append("Title1: \(Thread.current)")
//    }
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1: \(Thread.current)")
        }
    }

    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){
            let title = "Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                let ttile3 = "Title3: \(Thread.current)"
                self.dataArray.append(ttile3)
           }
        }
    }
    
    
    func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2 : \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(author2)
            
            let author3 = "Author3 : \(Thread.current)"
            self.dataArray.append(author3)

        })
        
//        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
//        let author3 = "Author3 : \(Thread.current)"
//        self.dataArray.append(author3)
        
//        await addBook()
    }
    
    func addBook() async {
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        let book1 = "Book1: \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(book1)

            let book2 = "Book2: \(Thread.current)"
            self.dataArray.append(book2)
        })
    }


}


struct AsyncAwaitBootcamp: View {
    
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
                
            }
        }
        .onAppear {
            
            Task {
                await viewModel.addAuthor1()
                await viewModel.addBook()
                
                let finalText = "Final Text: \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
            
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
            .preferredColorScheme(.dark)
    }
}