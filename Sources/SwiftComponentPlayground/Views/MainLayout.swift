import SwiftUI

struct MainLayout: View {
    @StateObject private var navigationManager = NavigationManager()
    @State private var isDrawerOpen = false

    var body: some View {
        ZStack(alignment: .leading) {
            Color.white.ignoresSafeArea()

            NavigationRouter(route: navigationManager.currentRoute)
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

            SlideOutDrawer(isShowing: $isDrawerOpen, navigationManager: navigationManager)
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
