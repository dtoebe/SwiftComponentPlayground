import SwiftUI

struct SlideOutDrawer: View {
    @State private var isShowing = false

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }

            VStack {
                Text("Drawer Menu")
                    .font(.title)
                Divider()
                    .overlay(.white)

                ForEach(1..<8) { index in
                    HStack {
                        Image(systemName: "waveform.circle.fill")
                        Text("Item: \(index)")
                        Spacer()
                    }
                    Divider()
                        .overlay(.white)
                }
                Text("By: Daniel Toebe")
                    .padding(.top, 10)
                    .font(.caption2)
            }
            .padding()
            .frame(minWidth: 225, maxWidth: 225)
            .background(.gray, in: RoundedRectangle(cornerRadius: 20))
            .foregroundStyle(.white)
            .offset(x: isShowing ? 0 : -300)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isShowing)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -50 {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            )
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 50 && value.startLocation.x < 50 {
                        withAnimation {
                            isShowing = true
                        }
                    }
                }
        )
    }
}
