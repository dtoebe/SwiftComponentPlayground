import SwiftUI

struct SlideOutDrawer: View {
    @Binding var isShowing: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text("Drawer Menu")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 10)
                .padding(.bottom, 7)

            Divider()
                .overlay(.white)

            ScrollView {
                ForEach(1..<10) { index in
                    HStack {
                        Image(systemName: "waveform.circle.fill")

                        Text("Item: \(index)")

                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)

                    Divider()
                        .overlay(.white)
                }
            }
            .background(.gray)

        }
        .frame(maxWidth: 250)
        .frame(maxHeight: .infinity)
        .background(.black)
        .foregroundStyle(.white)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 10,
                topTrailingRadius: 10
            )
        )
        .padding(.vertical, 10)
        .offset(x: isShowing ? 0 : -275)
        .animation(.spring(), value: isShowing)
    }
}
