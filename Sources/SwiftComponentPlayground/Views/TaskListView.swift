import SwiftData
import SwiftUI

struct TaskList: View {
    let tasks: [String] = (0..<10).map { "Task: \($0)" }

    @State private var selectedTask = ""
    @State private var showingSheet = false

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
                            showingSheet = true
                            selectedTask = ""
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                EditTask(name: selectedTask)
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
