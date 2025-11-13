import Foundation

struct NavigationItem: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let icon: String
    let route: String
    let badge: Int?
    let isEnabled: Bool

    init(
        title: String,
        icon: String,
        route: String,
        badge: Int? = nil,
        isEnabled: Bool = true
    ) {
        self.title = title
        self.icon = icon
        self.route = route
        self.badge = badge
        self.isEnabled = isEnabled
    }
}
