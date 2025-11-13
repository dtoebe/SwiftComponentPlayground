import SwiftUI

struct MainLayout<Content: View>: View {
    @State private var isDrawerOpen = false

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .leading) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if isDrawerOpen {
                Color.gray.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isDrawerOpen = false
                        }
                    }
            }

            SlideOutDrawer(isShowing: $isDrawerOpen)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 && value.startLocation.x < 50 {
                        withAnimation(.spring()) {
                            isDrawerOpen = true
                        }
                    }
                }
        )
    }
}
