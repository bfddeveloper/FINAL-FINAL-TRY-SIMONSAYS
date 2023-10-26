//
//  ContentView.swift
//  FINAL FINAL TRY SIMONSAYS
//
//  Created by Brody Dickson on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @State private var flash = [false, false, false, false]
    @State private var colorDisplay = [ColorDisplay(color: .green), ColorDisplay(color: .red), ColorDisplay(color: .yellow), ColorDisplay(color: .blue)]
    @State private var timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    @State var index = 1
    @State var sequence = [Int]()
    @State var score = 0
    @State var GameOVerOpac = 1.0
    @State var PlayerActive = false
    @State var PlayerTalk = "Your turn"
    var body: some View {
        VStack {
            Button("Play"){
                GameOVerOpac = 0.0
                flashColorDisplay(index: index)
                
            }
            Text("YOU FUCKING LOST BITCH")
                .font(.system(size: 36))
                .opacity(GameOVerOpac)
            Text(String(score))
            HStack{
                colorDisplay[0]
                    .opacity(flash[0] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 0)}
                colorDisplay[1]
                    .opacity(flash[1] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 1)
                        if index == 1 {
                            score += 1
                        } else {
                            GameOver()
                        }
                    }
            }
            HStack{
                colorDisplay[2]
                    .opacity(flash[2] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 2)
                        if index == 2 {
                            score += 1
                        } else {
                            GameOver()
                        }
                    }
                colorDisplay[3]
                    .opacity(flash[3] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: 3)
                        if index == 3 {
                            score += 1
                        } else {
                            GameOver()
                        }
                        
                        
                        
                    }
            }
            
        }
        .padding()
        .preferredColorScheme(.dark)
        .onReceive(timer) { _ in
                if index < sequence.count {
                    flashColorDisplay(index: sequence[index])
                    index += 1
                    PlayerActive = true
                } else {
                        index = 0
                        sequence.append(Int.random(in: 0...3))
                }
            
        }
        
    }
    func GameOver() {
        score = 0
        PlayerTalk = "YOU LOST YOU FUCKING BITCH"
        index = 0
    }
    func flashColorDisplay(index: Int) {
           flash[index].toggle()
           withAnimation(.easeInOut(duration: 0.5)) {
               flash[index].toggle()
           }
       }
}


struct ColorDisplay: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(color)
            .frame(width: 100, height: 100, alignment: .center)
            .padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
