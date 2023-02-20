//
//  ContentView.swift
//  FirebaseDynamicLinkTutorial
//
//  Created by liam on 2023/02/20.
//

import SwiftUI

struct ContentView: View {
    // TODO: Dynamic Link Handler 구현
    
    @State var list: [Car] = [
        Car(maker: "현대", name: "아이오닉"),
        Car(maker: "현대", name: "포터"),
        Car(maker: "토요타", name: "아발론"),
        Car(maker: "토요타", name: "센추리"),
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List(list) { car in
                    NavigationLink(destination: DetailView(
                        maker: car.maker,
                        name: car.name)) {
                        Text("\(car.maker) \(car.name)")
                    }
                }.listStyle(.plain)
            }
            .navigationBarTitle("자동차")
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
