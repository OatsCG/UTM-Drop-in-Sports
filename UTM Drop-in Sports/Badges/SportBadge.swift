//
//  SportMedal.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-10-05.
//

import SwiftUI

@available(iOS 18.0, *)
struct SportMedal: View {
    @State var size: CGFloat = 200
    @State var rotation: Double = 0
    var body: some View {
        SportMedalRotation(size: $size, rotation: $rotation)
    }
}

@available(iOS 18.0, *)
struct SportMedalRotation: View {
    @Binding var size: CGFloat
    @Binding var rotation: Double
    @State var lastRotation: CGFloat = 0

    var body: some View {
        SportMedalGlisten(size: $size, rotation: $rotation)
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.4
            )
//            .onAppear {
//                withAnimation(.linear.speed(0.1).repeatForever(autoreverses: false)) {
//                    rotation = 360
//                }
//            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Track how much the user has dragged
                        let dragAmount = value.translation.width
                        print(rotation)
                        withAnimation {
                            rotation = dragAmount + lastRotation
                        }
                    }
                    .onEnded { value in
                        // Calculate flick velocity to apply momentum
                        lastRotation = value.predictedEndTranslation.width
                        withAnimation(.interpolatingSpring(.smooth)) {
                            rotation = value.predictedEndTranslation.width
                        }
//                        withAnimation(.linear.speed(0.1).repeatForever(autoreverses: false)) {
//                            rotation += 360
//                        }
                    }
            )
    }
}



@available(iOS 18.0, *)
struct SportMedalGlisten: View {
    @Binding var size: CGFloat
    @Binding var rotation: Double
    @State var poses: [CGPoint] = [CGPoint(x: 50, y: 50)]
    var body: some View {
        SportMedalMedallion(size: $size)
            .overlay {
                GeometryReader { geo in
                    Group {
                        ForEach(poses, id: \.self) { pos in
                            SportMedalSingleGlisten(rotation: $rotation, x: pos.x)
                                .position(
                                    x: pos.x,
                                    y: pos.y
                                )
                                
                        }
                    }
                    .onAppear {
                        print("here!")
                        poses = (0..<100).map { _ in CGPoint(x: CGFloat.random(in: 0...geo.size.width), y: CGFloat.random(in: 0...geo.size.height)) }
                    }
                    .clipShape(Circle())
                }
            }
    }
}


@available(iOS 18.0, *)
struct SportMedalSingleGlisten: View {
    @Binding var rotation: Double
    var x: Double
    @State var peak: Double = 0
    var body: some View {
        Circle()
            .fill(
                .white.opacity(
                    glistenCalc(x: Double(rotation.truncatingRemainder(dividingBy: 180)), peak: peak)
                )
            )
            .onAppear {
                peak = Double.random(in: 0..<180)
            }
            .blendMode(.softLight)
            .frame(width: 1, height: 1)
            .animation(.linear, value: rotation)
    }
}

func glistenCalc(x: Double, peak: Double) -> Double {
    print(x, peak)
    if x < peak - 180 {
        return 0
    } else if x > peak + 180 {
        return 0
    } else {
        let f = pow((1 + cos((Double.pi / 180) * (x - peak))) / 2, 2)
        return f
    }
}

@available(iOS 18.0, *)
struct SportMedalMedallion: View {
    @Binding var size: CGFloat
    var body: some View {
        Group {
            SportMedalBG()
                .overlay(alignment: .center) {
                    SportMedalSymbol(size: $size)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .yellow.mix(with: .orange, by: 0.3),
                                    .yellow.mix(with: .white, by: 0.2)
                                ],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing)
                        )
                        .shadow(radius: size * 0.04, x: -size * 0.015, y: size * 0.015)
                }
                .padding(size * 0.04)
                .background(
                    Circle().fill(
                        LinearGradient(
                            colors: [
                                .yellow.mix(with: .orange, by: 0.4),
                                .yellow.mix(with: .orange, by: 0.2),
                                .yellow.mix(with: .white, by: 0.2),
                                .yellow.mix(with: .white, by: 0.2),
                                .yellow.mix(with: .white, by: 0.0)
                            ],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                )

        }
        .frame(width: size, height: size)
    }
}

@available(iOS 18.0, *)
struct SportMedalSymbol: View {
    @Binding var size: CGFloat
    @State var imgPadding: CGFloat = 0
    var body: some View {
        Image(.figureIndoorRowing)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay {
                SportMedalCalc(size: $size, imgPadding: $imgPadding)
            }
            .padding(imgPadding)
    }
}

@available(iOS 18.0, *)
struct SportMedalCalc: View {
    @Binding var size: CGFloat
    @Binding var imgPadding: CGFloat
    var body: some View {
        GeometryReader { geo in
            Rectangle().fill(.clear)
                .onAppear {
                    Task.detached {
                        let g = sqrt(pow(geo.size.width, 2) + pow(geo.size.height, 2))
                        let a = geo.size.height / geo.size.width
                        // calcing v
                        let num = await pow(g - size, 2)
                        let den = (1 / pow(a, 2)) + 1
                        let v = sqrt(num / den) / 2
                        let h = v / a
                        let p = await max(v, h) + (size * 0.04)
                        DispatchQueue.main.async {
                            imgPadding = p
                        }
                    }
                }
        }
    }
}

@available(iOS 18.0, *)
struct SportMedalBG: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        if colorScheme == .dark {
            Circle().fill(
                LinearGradient(
                    colors: [
                        .blueUTMlight.mix(with: .black, by: 0.45),
                        .blueUTMlight.mix(with: .black, by: 0.25)
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
        } else {
            Circle().fill(
                LinearGradient(
                    colors: [
                        .blueUTMlight.mix(with: .black, by: 0.35),
                        .blueUTMlight.mix(with: .black, by: 0.15)
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
        }
    }
}



@available(iOS 18.0, *)
#Preview {
    SportMedal()
}
