import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var items: [NavigationItem] = []
    @Published var currentRoute = "home"

    init() {
        loadNavigationItems()
    }

    private func loadNavigationItems() {
        items = [
            NavigationItem(title: "Home", icon: "house.fill", route: "home"),
            NavigationItem(title: "Time Picker", icon: "clock.fill", route: "timePicker"),
        ]
    }

    func navigate(to route: String) {
        currentRoute = route
    }

    func addItem(_ item: NavigationItem) {
        items.append(item)
    }
}

struct NavigationRouter: View {
    let route: String

    var body: some View {
        switch route {
        case "home":
            Home()
        case "timePicker":
            TimePickerView()
        default:
            Home()

        }
    }
}
