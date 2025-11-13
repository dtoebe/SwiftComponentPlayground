import Foundation
import SwiftUI

struct SlideOutDrawer: View {
    @Binding var isShowing: Bool
    @ObservedObject var navigationManager: NavigationManager

    var body: some View {
        VStack(spacing: 0) {
            Text("Menu")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 10)
                .padding(.bottom, 7)

            Divider()
                .overlay(.white)

            ScrollView {
                ForEach(navigationManager.items) { item in
                    NavigationButton(
                        item: item,
                        isSelected: navigationManager.currentRoute == item.route
                    ) {
                        navigationManager.navigate(to: item.route)
                        withAnimation(.spring) {
                            isShowing = false
                        }
                    }

                    Divider()
                        .overlay(.black.opacity(0.5))
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

struct NavigationButton: View {
    let item: NavigationItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .frame(width: 24)

                Text(item.title)
                    .font(.body)

                if let badge = item.badge {
                    Text("\(badge)")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.red)
                        .clipShape(Capsule())
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(isSelected ? .white.opacity(0.2) : .clear)
        }
        .buttonStyle(.plain)
        .disabled(!item.isEnabled)
        .opacity(item.isEnabled ? 1.0 : 0.5)

    }
}
