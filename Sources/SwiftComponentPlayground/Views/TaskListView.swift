import SwiftData
import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct TaskList: View {
    let tasks: [String] = (0..<10).map { "Task: \($0)" }

    @State private var selectedTask: String?

    var body: some View {
        #if os(iOS)
            NavigationStack {
                VStack {
                    List {
                        ForEach(tasks, id: \.self) { task in
                            HStack {
                                Text(task)
                                Spacer()
                                Button(action: {
                                }) {
                                    Image(systemName: "checkmark.circle")
                                }
                                .foregroundColor(.green)

                                Button(action: {
                                    selectedTask = task

                                }) {
                                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                }
                                .foregroundColor(.accentColor)
                                Button(action: {

                                }) {
                                    Image(systemName: "trash.fill")
                                }
                                .foregroundColor(.red)

                            }
                        }
                    }
                }
                .navigationTitle("Task List")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            selectedTask = ""
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .sheet(item: $selectedTask) { task in
                EditTask(name: task)
            }
        #endif
    }
}

struct EditTask: View {
    @Environment(\.dismiss) var dismiss

    @State private var name: String

    init(name: String) {
        _name = State(initialValue: name)
    }

    var body: some View {
        #if os(iOS)
            NavigationStack {
                VStack {
                    Form {
                        TextField("Name", text: $name)
                        Button("Save") {
                            dismiss()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        #endif
    }
}
