import SwiftUI

class TaskItem: Identifiable {
    var id: UUID
    var name: String
    var isComplete: Bool

    init(id: UUID = UUID(), name: String, isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.isComplete = isComplete
    }
}
