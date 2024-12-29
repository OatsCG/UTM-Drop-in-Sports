//
//  SportMedal.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-10-05.
//

import SwiftUI

struct SportMedal: View {
    @State var size: CGFloat = 200
    @State var rotation: Double = 0
    var symbol: ImageResource
    var colorPrimary: Color
    var colorSecondary: Color
    var body: some View {
        SportMedalRotation(size: $size, rotation: $rotation, symbol: symbol, colorPrimary: colorPrimary, colorSecondary: colorSecondary)
    }
}

struct SportMedalRotation: View {
    @Binding var size: CGFloat
    @Binding var rotation: Double
    @State var lastRotation: CGFloat = 0
    var symbol: ImageResource
    
    var colorPrimary: Color
    var colorSecondary: Color
    
    @State private var isFingerDown = false
    @State private var timer: Timer?
    @State var rotationDirection: Double = 1;
    
    @State var timeOfLiftoff: Date = Date()
    @State var beginningDegrees: Date = Date()
    

    var body: some View {
        SportMedalGlisten(size: $size, rotation: $rotation, symbol: symbol, colorPrimary: colorPrimary, colorSecondary: colorSecondary)
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.4
            )
            .onAppear {
                Task.detached {
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    DispatchQueue.main.async {
                        withAnimation(.interpolatingSpring(duration: 1.4)) {
                            rotation += 360 * 1.5
                        }
                    }
                    try? await Task.sleep(nanoseconds: 400_000_000)
                    DispatchQueue.main.async {
                        self.timeOfLiftoff = Date()
                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                            rotation += 360 * self.rotationDirection
                        }
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isFingerDown {
                            self.isFingerDown = true
                            rotation += calculateDegreesSinceLiftoff()
                            lastRotation = rotation
                        }
                        // Track how much the user has dragged
                        let dragAmount = value.translation.width
                        withAnimation {
                            rotation = lastRotation + (dragAmount * 0.7)
                        }
                    }
                    .onEnded { value in
                        // Calculate flick velocity to apply momentum
                        if #available(iOS 17.0, *) {
                            withAnimation(.interpolatingSpring(.smooth)) {
                                rotation = lastRotation + (value.predictedEndTranslation.width * 0.4)
                            }
                        } else {
                            withAnimation(.smooth) {
                                rotation = lastRotation + (value.predictedEndTranslation.width * 0.4)
                            }
                        }
                        lastRotation = value.predictedEndTranslation.width
                        if value.velocity.width > 0 {
                            self.rotationDirection = 1
                        } else {
                            self.rotationDirection = -1
                        }
                        self.isFingerDown = false
                        self.timeOfLiftoff = Date()
                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                            rotation += 360 * self.rotationDirection
                        }
                    }
            )
    }
    func calculateDegreesSinceLiftoff() -> Double {
        let timeInterval = Date().timeIntervalSince(timeOfLiftoff)
        let deg = 360 * (timeInterval / 4)
        let r = rotationDirection * Double(Int(deg.rounded()) % 360)
        return r
    }
//    func startIncrementingAnimation() {
////        self.timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
////            if !self.isFingerDown {
////                withAnimation(.linear(duration: 0.5)) { // .linear(duration: 0.2)
////                    rotation += 36 * rotationDirection
////                    self.lastRotation = rotation
////                }
////            }
////        }
//    }
}


struct SportMedalGlisten: View {
    @Binding var size: CGFloat
    @Binding var rotation: Double
    @State var poses: [CGPoint] = [CGPoint(x: 50, y: 50)]
    var symbol: ImageResource
    var colorPrimary: Color
    var colorSecondary: Color
    var body: some View {
        SportMedalMedallion(size: $size, symbol: symbol, colorPrimary: colorPrimary, colorSecondary: colorSecondary)
            .overlay {
                GeometryReader { geo in
                    Group {
                        ForEach(poses, id: \.hashValue) { pos in
                            SportMedalSingleGlisten(rotation: $rotation, x: pos.x)
                                .position(
                                    x: pos.x,
                                    y: pos.y
                                )
                        }
                    }
                    .onAppear {
                        poses = (0..<100).map { _ in CGPoint(x: CGFloat.random(in: 0...size), y: CGFloat.random(in: 0...size)) }
                    }
                    .onChange(of: size) { _ in
                        poses = (0..<100).map { _ in CGPoint(x: CGFloat.random(in: 0...size), y: CGFloat.random(in: 0...size)) }
                    }
                    .clipShape(Circle())
                }
            }
    }
}


struct SportMedalSingleGlisten: View {
    @Binding var rotation: Double
    var x: Double
    @State var peak: Double = 0
    @State var opac: Double = 0
    var body: some View {
        Circle()
            .fill(.white.opacity(opac))
            .onAppear {
                peak = Double.random(in: 0..<360)
            }
            .onChange(of: rotation) { _ in
                Task.detached {
                    let calc = await glistenCalc(x: mod(x: rotation, y: 360), peak: peak)
                    DispatchQueue.main.async {
                        self.opac = calc
                    }
                }
            }
            .blendMode(.softLight)
            .frame(width: 2, height: 2)
            .animation(.linear, value: rotation)
    }
}

func mod(x: Double, y: Double) -> Double {
    let i = Int(x.rounded())
    let j = Int(y.rounded())
    return Double(i % j)
}

func glistenCalc(x: Double, peak: Double) -> Double {
//    if x < peak - 180 {
//        return 0
//    } else if x > peak + 180 {
//        return 0
//    } else {
//        let f = pow((1 + cos((Double.pi / 180) * (x - peak))) / 2, 2)
//        return f
//    }
    let f = pow((1 + cos((Double.pi / 180) * (x - peak))) / 2, 2)
    return pow(f, 3)
}


struct SportMedallionDisplay: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var size: CGFloat
    var medal: Medal
    @State var showingSheet: Bool = false
    @Namespace var animation
    var body: some View {
        Button(action: {
            showingSheet.toggle()
        }) {
            if #available(iOS 18.0, *) {
                VStack(alignment: .center) {
                    ZStack {
                        SportMedalMedallion(size: $size, symbol: ImageResource(name: medal.icon, bundle: .main), colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary)
                            .padding(.bottom, 10)
                            .background(alignment: .bottom) {
                                VStack(spacing: 0) {
                                    Trapezoid(topWidthRatio: 0.7)
                                        .stroke(.primary.opacity(0.2), lineWidth: 1)
                                        .fill(LinearGradient(gradient: Gradient(colors: [.primary.opacity(0.08), .primary.opacity(0.38)]), startPoint: .top, endPoint: .bottom))
                                        .frame(height: 14)
                                    Rectangle()
                                        .stroke(.primary.opacity(0.2), lineWidth: 1)
                                        .fill(.primary.opacity(0.4))
                                        .frame(height: 5)
                                }
                                .opacity(colorScheme == .dark ? 1 : 0.35)
                            }
                    }
                    Text(medal.category)
                        .font(.body .bold())
                }
                .matchedTransitionSource(id: medal.category, in: animation)
            } else {
                VStack(alignment: .center) {
                    SportMedalMedallion(size: $size, symbol: ImageResource(name: medal.icon, bundle: .main), colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary)
                    Text(medal.category)
                        .font(.body .bold())
                }
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingSheet) {
            if #available(iOS 18.0, *) {
                SportMedalSheet(medal: medal, colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary, showingSheet: $showingSheet)
                    .navigationTransition(.zoom(sourceID: medal.category, in: animation))
            } else {
                SportMedalSheet(medal: medal, colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary, showingSheet: $showingSheet)
            }
        }
    }
}

struct Trapezoid: Shape {
    var topWidthRatio: CGFloat // Ratio of the top width to the rectangle's total width.
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let topWidth = rect.width * topWidthRatio
        let offsetX = (rect.width - topWidth) / 2
        
        path.move(to: CGPoint(x: offsetX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - offsetX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct SportMedalSheet: View {
    @State var size: CGFloat = 100
    var medal: Medal
    @State var rotation: Double = 0
    var colorPrimary: Color
    var colorSecondary: Color
    @Binding var showingSheet: Bool
    var body: some View {
        VStack {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        self.size = min(geo.size.width, geo.size.height)
                    }
                    .onChange(of: geo.size) { _ in
                        self.size = min(geo.size.width, geo.size.height)
                    }
            }
            .padding(50)
            .overlay {
                ZStack {
                    VStack {
                        Button(action: {
                            showingSheet = false
                        }) {
                            Image(systemName: "chevron.compact.down")
                                .foregroundStyle(.secondary)
                                .font(.title)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 15)
                        Spacer()
                    }
                    VStack {
                        if medal.type == .none {
                            SportMedalEmpty(size: $size, medal: medal)
                                .padding(.bottom, 15)
                            Text(medal.category)
                                .font(.largeTitle .bold())
                            Text("Sessions: \(medal.events.count)")
                                .font(.title2 .bold())
                                .padding(.bottom, 25)
                            Text("Participate in a \(medal.category) session to earn this medal.\n**Save \(Image(systemName: "bookmark"))**  a future session to participate.")
                        } else {
                            SportMedalRotation(size: $size, rotation: $rotation, symbol: ImageResource(name: medal.icon, bundle: .main), colorPrimary: colorPrimary, colorSecondary: colorSecondary)
                                .padding(.bottom, 15)
                            Text(medal.category)
                                .font(.largeTitle .bold())
                            Text("Sessions: \(medal.events.count)")
                                .font(.title2 .bold())
                                .padding(.bottom, 25)
                            if medal.type == .bronze {
                                Text("Complete 5 sessions to earn a **Silver** medal.")
                            } else if medal.type == .silver {
                                Text("Complete 10 sessions to earn a **Gold** medal.")
                            }
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct SportMedalMedallion: View {
    @Binding var size: CGFloat
    var symbol: ImageResource
    var colorPrimary: Color
    var colorSecondary: Color
    var body: some View {
        Group {
            SportMedalBG(colorPrimary: colorPrimary, colorSecondary: colorSecondary)
                .overlay(alignment: .center) {
                    SportMedalSymbol(size: $size, symbol: symbol)
                        .foregroundStyle(colorPrimary)
                        .overlay {
                            SportMedalSymbol(size: $size, symbol: symbol)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            colorSecondary.opacity(0.4),
                                            .white.opacity(0.3)
                                        ],
                                        startPoint: .bottomLeading,
                                        endPoint: .topTrailing)
                                )
                        }
                        .shadow(radius: size * 0.04, x: -size * 0.015, y: size * 0.015)
                }
                .padding(size * 0.04)
                .background(
                    Circle().fill(colorPrimary)
                    .overlay {
                        Circle().fill(
                            LinearGradient(
                                colors: [
                                    colorSecondary.opacity(0.5),
                                    colorSecondary.opacity(0.3),
                                    .white.opacity(0.3),
                                    .white.opacity(0.3),
                                    .white.opacity(0.0)
                                ],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                        )
                    }
                )

        }
        .frame(width: size, height: size)
    }
}


struct SportMedalSymbol: View {
    @Binding var size: CGFloat
    @State var imgPadding: CGFloat = 0
    var symbol: ImageResource
    var body: some View {
        SportMedalCalc(size: $size, imgPadding: $imgPadding)
            .overlay {
                Image(symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(imgPadding)
            }
    }
}


struct SportMedalCalc: View {
    @Binding var size: CGFloat
    @Binding var imgPadding: CGFloat
    var body: some View {
        GeometryReader { geo in
            Rectangle().fill(.clear)
                .onAppear {
                    let geoWidth: CGFloat = geo.size.width
                    let geoHeight: CGFloat = geo.size.height
                    let g = sqrt(pow(geoWidth, 2) + pow(geoHeight, 2)) + (size * 0.12)
                    let a = geoHeight / geoWidth
                    // calcing v
                    let num = pow(g - size, 2)
                    let den = (1 / pow(a, 2)) + 1
                    let v = sqrt(num / den) / 2
                    let h = v / a
                    let p = max(v, h)
                    imgPadding = p
                }
                .onChange(of: geo.size) { _ in
                    let geoWidth: CGFloat = geo.size.width
                    let geoHeight: CGFloat = geo.size.height
                    let g = sqrt(pow(geoWidth, 2) + pow(geoHeight, 2)) + (size * 0.12)
                    let a = geoHeight / geoWidth
                    // calcing v
                    let num = pow(g - size, 2)
                    let den = (1 / pow(a, 2)) + 1
                    let v = sqrt(num / den) / 2
                    let h = v / a
                    let p = max(v, h)
                    DispatchQueue.main.async {
                        imgPadding = p
                    }
                }
        }
    }
}

struct SportMedalBG: View {
    @Environment(\.colorScheme) private var colorScheme
    var colorPrimary: Color
    var colorSecondary: Color
    var body: some View {
        if colorScheme == .dark {
            Circle().fill(
                LinearGradient(
                    colors: [
                        colorSecondary,
                        colorPrimary
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .overlay {
                Circle().fill(
                    LinearGradient(
                        colors: [
                            .black.opacity(0.45),
                            .black.opacity(0.25),
                        ],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
            }
        } else {
            Circle().fill(
                LinearGradient(
                    colors: [
                        colorSecondary,
                        colorPrimary
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .overlay {
                Circle().fill(
                    LinearGradient(
                        colors: [
                            .black.opacity(0.25),
                            .black.opacity(0.15),
                        ],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
            }
        }
    }
}



#Preview {
    SportMedal(symbol: .figureIndoorRowing, colorPrimary: .orange, colorSecondary: .orange)
}
