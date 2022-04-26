//
//  DoTryCatchThrowsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 4/26/22.
//

import SwiftUI

// Swift Concurrency [or Writing Asynchronus Code in Swift]:
/*
 previously we did concurrency(asynchronus code) using two ways predominently
    1. Escaping Closures
    2. Combine
 */

// Keywords:
/*
    1. do-try
    2. catch
    3. throw
    4. throws
 */

class DoTryCatchThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title:String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    // better code than above method
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else {
            return .failure(URLError(.backgroundSessionInUseByAnotherProcess))
        }
    }
    
    
    // better code than above method
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }

    // better code than above method
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }

}

class DoTryCatchThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting Text..."
    let manager = DoTryCatchThrowsBootcampDataManager()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        
        /*
        let result = manager.getTitle2()
        
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        
        // here we need to take care of error
        // and also need to handle errors properly
        // so used try
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        } catch {
            self.text = error.localizedDescription
        }
        
        // here we don't care about error
        // so used try?
        let newTitle = try? manager.getTitle4()
        if let newTitle = newTitle {
            self.text = newTitle
        }
        
        
    }
}

struct DoTryCatchThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoTryCatchThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct ConcurrencyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoTryCatchThrowsBootcamp()
    }
}
