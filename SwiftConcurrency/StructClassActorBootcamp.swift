//
//  StructClassActorBootcamp.swift
//  SwiftConcurrency
//
//  Created by Sivaram Yadav on 5/18/22.
//

import SwiftUI

// Topics include:
/*
     1. Structs vs Classes vs Actors
     2. Value vs Reference Types
     3. Stack vs Heap memory
     4. Automatic Reference Counting (ARC) in Swift
     5. Weak vs Strong References

     Links:
     - https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/
     - https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
     - https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
     - https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
     - https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
     - https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
     - https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
     - https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
 */

// Summary:
/*
 
 VALUE TYPES:
     - Struct, Enum, String, Int etc.
     - Stored in the Stack memory.
     - Faster
     - Thread Safe!
     - When we assign or pass a value type, compiler creates a new copy of data is created.
 
 REFERENCE TYPES:
     - Class, Function, Closure and Actor.
     - Stored in the Heap memory.
     - Slower, but synchronized.
     - NOT Thread safe.
     - When we assign or pass a reference type, compiler will creates a new reference to the original instance(object).
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 STACK:
     - Stores Value types
     - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast.
     - Each thread has its own stack!
 
 HEAP:
     - Stores Reference types
     - Shared across threads!
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 STRUCT:
     - Based on VALUES
     - Can be mutated
     - Stored in the Stack!
 
 CLASS:
     - Based on REFERENCES
     - Stored in the Heap
     - Inheit from other classes
     -
 
 ACTOR:
     - Same as Class, but Thread safe!
 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 
 When should we use STRUCT vs CLASS vs ACTOR ?
 
    - STRUCTs -> used for -> Data Models and Views.
    - CLASSs  -> used for -> ViewModels.
    - ACTORs  -> used for -> Shared 'Manager' or 'Data Store' or else any kind of Shared thing across many places on many threads.

 */

actor StructClassActorBootcampDataManager {
    
    func getDataFromDatabase() {
        
    }
}

class StructClassActorBootcampViewModel: ObservableObject {
    
    @Published var title: String = " "
    
    init() {
        print("ViewModel INIT")
    }
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel = StructClassActorBootcampViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View INIT")
    }
    
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
//                runTest()
            }
    }
}

struct StructClassActorBootcampHomeView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp(isActive: true)
    }
}


extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test started!")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func structTest1() {
        print(#function)
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA:", objectA.title)
        
        print("Passed the VALUES of ObjectA to ObjectB.")
        var objectB = objectA
        print("ObjectB:", objectB.title)
        
        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA:", objectA.title)
        print("ObjectB:", objectB.title)
    }
    
    private func printDivider() {
        print("""
        
        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        """)
    }
    
    private func classTest1() {
        print(#function)
        let objectA = MyClass(title: "Starting title!")
        print("ObjectA:", objectA.title)

        print("Passed the REFERENCE of ObjectA to ObjectB.")
        let objectB = objectA
        print("ObjectB:", objectB.title)

        objectB.title = "Second title!"
        print("ObjectB title changed.")
        
        print("ObjectA:", objectA.title)
        print("ObjectB:", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print(#function)
            let objectA = MyActor(title: "Starting title!")
            await print("ObjectA:", objectA.title)
            
            print("Passed the REFERENCE of ObjectA to ObjectB.")
            let objectB = objectA
            await print("ObjectB:", objectB.title)
            
            // objectB.title = "Second title!"
            // here getting error like -> "Actor-isolated property 'title' can not be mutated from a non-isolated context"
            // in order to fix that error need to do like below
            await objectB.updateTitle(newTitle: "Second title!")
            print("ObjectB title changed.")
            
            await print("ObjectA:", objectA.title)
            await print("ObjectB:", objectB.title)
        }
    }

}

struct MyStruct {
    var title: String
}

// immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }

    mutating func updateTitle(newTitle: String) {
        self.title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func structTest2() {
        print(#function)
        var struct1 = MyStruct(title: "Title1")
        print("Struct1 title: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1 title: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2 title: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2 title: ", struct2.title)

        var struct3 = CustomStruct(title: "Title1")
        print("Struct3 title: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3 title: ", struct3.title)

        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4 title: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4 title: ", struct4.title)

    }
}


class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        self.title = newTitle
    }

}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        self.title = newTitle
    }

}


extension StructClassActorBootcamp {
    
    private func classTest2() {
        print(#function)
        
        let class1 = MyClass(title: "Title1")
        print("Class1 title: ", class1.title)
        class1.title = "Title2"
        print("Class1 title: ", class1.title)

        let class2 = MyClass(title: "Title1")
        print("Class2 title: ", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class2 title: ", class2.title)

    }
}
