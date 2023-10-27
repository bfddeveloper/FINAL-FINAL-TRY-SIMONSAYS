import SwiftUI

struct ContentView: View {
    @State private var flash = [false, false, false, false]
    @State private var colorDisplay = [ColorDisplay(color: .green), ColorDisplay(color: .red), ColorDisplay(color: .yellow), ColorDisplay(color: .blue)]
    @State var sequence = [Int]()
    @State var score = 0
    @State var gameOverOpacity = 0.0
    @State var playerActive = false
    @State var playerTalk = "Your turn"

    var body: some View {
        VStack {
            Button("Play") {
                gameOverOpacity = 0.0
                sequence = [Int.random(in: 0...3)]
                flashColorSequence()
            }
            Text("YOU LOST")
                .font(.system(size: 36))
                .opacity(gameOverOpacity)
            Text("Score: \(score)")
            VStack {
                HStack {
                    colorDisplay[0]
                        .opacity(flash[0] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(0)
                            flashColorDisplay(index: 0)
                        }
                    colorDisplay[1]
                        .opacity(flash[1] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(1)
                            flashColorDisplay(index: 1)
                        }
                }
                HStack {
                    colorDisplay[2]
                        .opacity(flash[2] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(2)
                            flashColorDisplay(index: 2)
                        }
                    colorDisplay[3]
                        .opacity(flash[3] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(3)
                            flashColorDisplay(index: 3)
                        }
                }
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }

    func gameOver() {
        score = 0
        playerTalk = "YOU LOST"
        playerActive = false
        gameOverOpacity = 1.0
    }

    func flashColorDisplay(index: Int) {
        flash[index].toggle()
        withAnimation(.easeInOut(duration: 0.5)) {
            flash[index].toggle()
        }
    }

    func flashColorSequence() {
        playerActive = false
        playerTalk = "Watch carefully"
        score = 0
        flashSequence(index: 0)
    }

    func flashSequence(index: Int) {
        if index < sequence.count {
            flashColorDisplay(index: sequence[index])
            let nextIndex = index + 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.flashSequence(index: nextIndex)
            }
        } else {
            playerActive = true
        }
    }

    func checkPlayerInput(_ input: Int) {
        if playerActive {
            if input == sequence[score] {
                if score < sequence.count - 1 {
                    score += 1
                } else {
                    score += 1
                    playerTalk = "Well done!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        addToSequence()
                    }
                }
            } else {
                gameOver()
            }
        }
    }

    func addToSequence() {
        sequence.append(Int.random(in: 0...3))
        flashColorSequence()
        score += 1
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

