//
//  PickerRow.swift
//  Plant Task
//

import SwiftUI

// Option نوع عام: أي enum يتبع RawRepresentable (String) وHashable
struct PickerRow<Option: Hashable & RawRepresentable>: View where Option.RawValue == String {
    var icon: String
    var title: String
    @Binding var selection: Option
    var options: [Option]
    // أيقونة لكل خيار (اختياري)، تجي من الـ enum نفسه
    var optionIcon: ((Option) -> String)? = nil

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    // إذا للخيار أيقونة نعرضها معه
                    if let iconName = optionIcon?(option) {
                        Label(option.rawValue, systemImage: iconName).tag(option)
                    } else {
                        Text(option.rawValue).tag(option)
                    }
                }
            }
            .pickerStyle(.menu)
            .accentColor(.gray)
        }
        .padding()
    }
}
