import SwiftUI
import SwiftData

struct PreloadedTask: Identifiable {
    let id = UUID()
    let image: String
    let text: String
    let colour: Color
}

struct PreloadedTaskView: View {
    @State private var newtask = ""
    @State private var goToAddNewHabit = false
    @Environment(\.modelContext) var modelContextx
    @Query(sort: \Activity.name)
    private var activities : [Activity]

    let tasks: [PreloadedTask] = [
        .init(image: "Answer Email", text: "Answer Email", colour: .blue.opacity(0.4)),
        .init(image: "Eat Breakfast", text: "Eat Breakfast", colour: .green.opacity(0.4)),
        .init(image: "Open the Windows", text: "Open the Windows", colour: .cyan.opacity(0.4)),
        .init(image: "Hair Cut", text: "Hair Cut", colour: Color.pink.opacity(0.4)),
        .init(image: "Take Pills", text: "Take Pills", colour: Color.yellow.opacity(0.6)),
        .init(image: "Walk", text: "Walk", colour: Color.orange.opacity(0.4)),
        .init(image: "Take dog to walk", text: "Take dog to walk", colour: Color.red.opacity(0.4)),
        .init(image: "write", text: "write", colour: Color.yellow.opacity(0.4)),
        .init(image: "Book movie tickets", text: "Book movie tickets", colour: Color.blue.opacity(0.5)),
        .init(image: "Development", text: "Development", colour: Color.cyan.opacity(0.5))
        
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    TextField("New Task", text: $newtask)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .listRowBackground(Color.clear)

                    if !newtask.isEmpty {
                        Text("Tap to rename")
                            .padding(3)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowBackground(Color.clear)
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        Text("Suggestions ?")
                            .font(.headline)
                            .padding(.horizontal)

                        // Preloaded tasks filtered by name
                        ForEach(tasks.filter { task in
                            newtask.isEmpty || task.text.lowercased().contains(newtask.lowercased())
                        }) { task in
                            NavigationLink(destination: AddNewHabit(habitName: task.text)) {
                                HStack {
                                    TaskView(image: task.image, text: task.text, colour: task.colour)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        Divider()
                            .padding(.vertical)

                        // Recently Added Activities filtered by name
                        if !activities.isEmpty {
                            Text("Recently Added")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(activities.filter { activity in
                                newtask.isEmpty || activity.name.lowercased().contains(newtask.lowercased())
                            }) { activity in
                                NavigationLink(destination: AddNewHabit(habitName: activity.name)) {
                                    TaskView(image: "default", text: activity.name, colour: activity.color.opacity(0.4))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding()
                }
                .padding(50)
            }

            NavigationLink(
                destination: AddNewHabit(habitName: newtask),
                isActive: $goToAddNewHabit,
                label: { EmptyView() }
            )

            if !newtask.isEmpty {
                Button {
                    goToAddNewHabit = true
                } label: {
                    Text("Continue")
                        .frame(width: 150, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black)
                        )
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    PreloadedTaskView()
}
