import SwiftData
import SwiftUI

extension String {
    var isEmptyOrWithWhitespace: Bool {
        self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

struct TaskList: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @Query var taskItems: [TaskItem]
    @State private var showingAddSheet = false
    @State private var selectedTask: TaskItem?

    var body: some View {
        NavigationStack {
            #if os(iOS)
                VStack {
                    List {
                        Section("To Do") {
                            ForEach(taskItems) { task in
                                if !task.isComplete {
                                    TaskRowView(task: task)
                                        .onTapGesture {
                                            selectedTask = task
                                        }
                                }
                            }
                            .onDelete(perform: deleteTask)
                        }
                        Section("Completed Tasks") {
                            ForEach(taskItems) { task in
                                if task.isComplete {
                                    TaskRowView(task: task)
                                        .onTapGesture {
                                            selectedTask = task
                                        }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Task List")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.accentColor)
                        }

                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    TaskDetailSheet(task: nil)
                }
                .sheet(item: $selectedTask) { task in
                    TaskDetailSheet(task: task)
                }
            #endif
        }
        .onAppear {
            TaskListSeedData.seedData()
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            context.delete(taskItems[index])
        }
    }
}

struct TaskRowView: View {
    @Bindable var task: TaskItem
    @State private var offset: CGFloat = 0
    @State private var showingCompleteIcon = false

    private let swipeThreshold: CGFloat = 80
    private let completeThreshold: CGFloat = 150

    var body: some View {
        ZStack(alignment: .leading) {
            if offset > 0 {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(5)
                    Spacer()
                }
                // .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    task.isComplete
                        ? .cyan.opacity(offset > swipeThreshold ? 1.0 : 0.5)
                        : .green.opacity(offset > swipeThreshold ? 1.0 : 0.5)
                )
                .cornerRadius(20)
            }

            if offset < 0 {
                HStack {
                    Spacer()
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    .red.opacity(abs(offset) < swipeThreshold ? 1.0 : 0.5)
                )
                .cornerRadius(20)
            }

            HStack {

                Text(task.name)
                    .strikethrough(task.isComplete)
                    .foregroundColor(task.isComplete ? .secondary : .primary)

                Spacer()

                if task.isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .offset(x: offset)
            .clipped()
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let traslation = gesture.translation.width

                        if traslation > 0 {
                            offset = min(traslation, 200)
                        } else {
                            offset = max(traslation, -200)
                        }

                    }
                    .onEnded { gesture in
                        let translation = gesture.translation.width

                        if translation > completeThreshold {
                            withAnimation(.spring(response: 0.3)) {
                                task.isComplete.toggle()
                                offset = 0
                            }
                        } else if translation < -completeThreshold {
                            withAnimation(.spring(response: 0.3)) {
                                task.isComplete.toggle()
                                offset = 0
                            }
                        } else {
                            withAnimation(.spring(response: 0.3)) {
                                offset = 0
                            }

                        }
                    }
            )
        }
    }
}

struct TaskDetailSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var isComplete: Bool

    private var task: TaskItem?
    private var isEditing: Bool { task != nil }

    init(task: TaskItem?) {
        self.task = task
        _name = State(initialValue: task?.name ?? "")
        _isComplete = State(initialValue: task?.isComplete ?? false)
    }

    private var isFormValid: Bool {
        !name.isEmptyOrWithWhitespace
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task Name", text: $name)
                }

                Section {
                    Toggle("Mark as Complete", isOn: $isComplete)
                }

                if isEditing {
                    Section {
                        Button(role: .destructive) {
                            deleteTask()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Delete Task")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Task" : "New Task")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Done" : "Add") {
                        saveTask()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }

    private func saveTask() {
        if let task = task {
            task.name = name
            task.isComplete = isComplete
        } else {
            let newTask = TaskItem(name, isComplete: isComplete)
            context.insert(newTask)
        }

        dismiss()
    }

    private func deleteTask() {
        if let task = task {
            context.delete(task)
            dismiss()
        }
    }
}
