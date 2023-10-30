import SwiftUI
import AVFoundation


struct ContentView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State private var flash = [false, false, false, false]
    @State private var colorDisplay = [ColorDisplay(color: .green, sound: "green_sound"),
                                          ColorDisplay(color: .red, sound: "red_sound"),
                                          ColorDisplay(color: .yellow, sound: "yellow_sound"),
                                          ColorDisplay(color: .blue, sound: "blue_sound")]
    @State var sequence = [Int]()
    @State var score = 0
    @State var HighScore = 0
    @State var gameOverOpacity = 0.0
    @State var playerActive = false
    @State var playerTalk = "Your turn"
    @State var level = 1
    var players: [AVAudioPlayer?] = [nil, nil, nil, nil]
    
    init() {
            for (index, colorDisplay) in colorDisplay.enumerated() {
                do {
                    if let fileURL = Bundle.main.url(forResource: colorDisplay.sound, withExtension: "mp3") {
                        players[index] = try AVAudioPlayer(contentsOf: fileURL)
                        players[index]?.prepareToPlay()
                    }
                } catch {
                    print("Error loading sound file: \(error.localizedDescription)")
                }
            }
        }

    var body: some View {
        VStack {
            Text("simon")
                .font(.system(size: 72))
            Button("Play") {
                gameOverOpacity = 0.0
                playSound("Start")
                sequence = [Int.random(in: 0...3)]
                flashColorSequence()
            }
            Text("YOU LOST")
                .font(.system(size: 36))
                .opacity(gameOverOpacity)
            Text(playerTalk)
            Text("HighScore: \(HighScore)")
            Text("Level: \(level)")
            VStack {
                HStack {
                    colorDisplay[0]
                        .opacity(flash[0] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(0)
                            flashColorDisplay(index: 0)
                            playSound("0")
                        }
                    colorDisplay[1]
                        .opacity(flash[1] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(1)
                            flashColorDisplay(index: 1)
                            playSound("1")
                        }
                }
                HStack {
                    colorDisplay[2]
                        .opacity(flash[2] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(2)
                            flashColorDisplay(index: 2)
                            playSound("2")
                        }
                    colorDisplay[3]
                        .opacity(flash[3] ? 1 : 0.4)
                        .onTapGesture {
                            checkPlayerInput(3)
                            flashColorDisplay(index: 3)
                            playSound("3")
                        }
                }
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }

    func gameOver() {
        score = 0
        level = 1
        if HighScore < level {
            HighScore = level
            playSound("HighScore")
            playerTalk = "New Highscore"
        } else {
            playSound("Lose")
            playerTalk = "LOSER"
        }
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
            playSound(String(index))
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
                score += 1
                if score == sequence.count {
                    playerTalk = "Well done!"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        level += 1
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
    }
    func playSound(_ soundFileName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav", subdirectory: "Sounds") else {
            fatalError("Unable to find \(soundFileName) in bundle")
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print(error.localizedDescription)
        }
        audioPlayer.play()
    }
}

struct ColorDisplay: View {
    let color: Color
    let sound: String
    
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

