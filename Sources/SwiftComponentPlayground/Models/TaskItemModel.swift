import SwiftData
import SwiftUI

@Model
class TaskItem: Identifiable {
    var id: UUID
    var name: String
    var isComplete: Bool

    init(_ name: String, id: UUID = UUID(), isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.isComplete = isComplete
    }
}
