import Foundation
import SwiftData

class TaskListSeedData {
    @MainActor
    static func seedData() {
        let container = try? ModelContainer(for: TaskItem.self)
        guard let context = container?.mainContext else { return }

        let fetchDescriptor = FetchDescriptor<TaskItem>()
        let existingCount = (try? context.fetchCount(fetchDescriptor)) ?? 0

        guard existingCount == 0 else { return }

        let sampleTasks = [
            TaskItem("Buy groceries", isComplete: false),
            TaskItem("Build a Project Management App", isComplete: true),
            TaskItem("Walk the dog", isComplete: false),
        ]

        for task in sampleTasks {
            context.insert(task)
        }

        try? context.save()
    }
}
