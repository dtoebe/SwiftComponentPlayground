import SwiftUI

struct TimePickerView: View {
    @State private var hour = 0
    @State private var minute = 0
    @State private var second = 0

    var body: some View {
        #if os(iOS)
            VStack {
                HStack {
                    TimePicker(
                        title: "HH", minNum: 0, maxNum: 10000, titleColor: Color.gray,
                        strokeColor: Color.gray, time: $hour
                    )

                    TimePicker(
                        title: "MM", minNum: 0, maxNum: 60, titleColor: Color.gray,
                        strokeColor: Color.gray, time: $minute
                    )

                    TimePicker(
                        title: "SS", minNum: 0, maxNum: 60, titleColor: Color.gray,
                        strokeColor: Color.gray, time: $second
                    )

                }
                .padding()

                Spacer()

                Text("Time Selected (HH:MM:SS): \(hour):\(minute):\(second)")
                    .font(.caption)
            }
        #elseif os(macOS)

        #endif
    }

}

struct TimePicker: View {
    let title: String
    let minNum: Int
    let maxNum: Int
    let titleColor: Color
    let strokeColor: Color

    @Binding var time: Int

    init(
        title: String, minNum: Int, maxNum: Int, titleColor: Color, strokeColor: Color,
        time: Binding<Int>
    ) {
        self.title = title
        self.minNum = minNum
        self.maxNum = maxNum
        self.titleColor = titleColor
        self.strokeColor = strokeColor
        self._time = time
    }

    var body: some View {
        #if os(iOS)
            VStack {
                Text(title)
                    .font(.title)
                    .foregroundStyle(titleColor)

                Picker(title, selection: $time) {
                    ForEach(minNum..<maxNum, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(strokeColor, lineWidth: 4)
                )
            }
        #endif
    }
}
