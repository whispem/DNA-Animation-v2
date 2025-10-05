//
//  ContentView.swift
//  DNA Animation v2
//
//  Created by Emilie on 02/10/2025.
//
import SwiftUI

let firstC = Color(UIColor(red: 0.57, green: 0.92, blue: 0.94, alpha: 1.00))
let secondC = Color(UIColor(red: 0.50, green: 0.50, blue: 0.87, alpha: 1.00))
let firstC1 = Color(UIColor(red: 0.92, green: 0.69, blue: 0.81, alpha: 1.00))
let secondC2 = Color(UIColor(red: 0.40, green: 0.31, blue: 0.69, alpha: 1.00))

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            DNALoading()
        }
    }
}

struct DNALoading: View {
    @State private var top: Bool = false
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfBalls, id: \.self) { i in
                DNABalls(
                    delay: Double(i)/4,
                    ballSpeed: ballSpeed,
                    ballSize: ballSize,
                    firstBallColor: firstBallColor,
                    secondBallColor: secondBallColor
                )
                .frame(width: ballSize, height: frameHeight)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: ballSpeed, repeats: true) { _ in
                top.toggle()
            }
        }
    }
    
    let numberOfBalls: Int = 5
    let spacing: CGFloat = 20
    let ballSpeed: Double = 0.75
    let ballSize: CGFloat = 30
    let frameHeight: CGFloat = 60
    let firstBallColor = LinearGradient(gradient: Gradient(colors: [firstC, secondC]), startPoint: .top, endPoint: .bottom)
    let secondBallColor = LinearGradient(gradient: Gradient(colors: [firstC1, secondC2]), startPoint: .top, endPoint: .bottom)
}

struct DNABalls: View {
    @State var delay: Double
    @State var ballSpeed: Double
    @State var ballSize: CGFloat
    @State var firstBallColor: LinearGradient
    @State var secondBallColor: LinearGradient
    @State private var top = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    DNABall(delay: 0 + delay, ballSpeed: ballSpeed, ballSize: ballSize, rect: geo.size, color: firstBallColor)
                        .zIndex(top ? 1 : 0)
                    DNABall(delay: ballSpeed + delay, ballSpeed: ballSpeed, ballSize: ballSize, rect: geo.size, color: secondBallColor)
                        .zIndex(top ? 0 : 1)
                }
                .opacity(top ? 1 : 0)
           
                ZStack {
                    DNABall(delay: ballSpeed + delay, ballSpeed: ballSpeed, ballSize: ballSize, rect: geo.size, color: secondBallColor)
                        .zIndex(top ? 0 : 1)
                    DNABall(delay: 0 + delay, ballSpeed: ballSpeed, ballSize: ballSize, rect: geo.size, color: firstBallColor)
                        .zIndex(top ? 1 : 0)
                }
                .opacity(top ? 0 : 1)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                Timer.scheduledTimer(withTimeInterval: ballSpeed, repeats: true) { _ in
                    top.toggle()
                }
            }
        }
    }
}

struct DNABall: View {
    @State var delay: Double
    @State var ballSpeed: Double
    @State var ballSize: CGFloat
    @State var rect: CGSize
    @State var color: LinearGradient
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: ballSize, height: ballSize)
            .offset(x: 0, y: -(rect.height/2))
            .offset(y: offsetY)
            .scaleEffect(scale)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.easeInOut(duration: ballSpeed).repeatForever(autoreverses: true)) {
                        offsetY = rect.height
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + ballSpeed/2) {
                        withAnimation(Animation.easeInOut(duration: ballSpeed).repeatForever(autoreverses: true)) {
                            scale = 0.65
                        }
                    }
                }
            }
    }
}
