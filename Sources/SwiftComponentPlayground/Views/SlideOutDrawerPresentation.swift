import SwiftUI

struct SlideOutDrawerPresentation: View {
    var body: some View {
        ZStack {

            VStack {
                HStack {
                    Text("Swipe Left...")
                        .font(.largeTitle)

                    Image(systemName: "chevron.forward")
                        .foregroundColor(.blue)
                        .font(.largeTitle)

                }
            }

            SlideOutDrawer()
        }
    }
}
