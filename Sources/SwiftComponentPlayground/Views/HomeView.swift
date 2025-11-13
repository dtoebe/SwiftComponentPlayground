import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            Text("Home Screen")
            NavigationLink("Go to TimePicker") {
                TimePickerView()
            }
        }
    }
}
