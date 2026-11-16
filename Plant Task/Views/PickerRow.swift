//
//  PickerRow.swift
//  Plant Task
//

import SwiftUI

struct PickerRow: View {
    var icon: String
    var title: String
    @Binding var selection: String
    var options: [String]
    // جديد: أيقونة لكل خيار (اختياري، الافتراضي فاضي)
    var optionIcons: [String: String] = [:]

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    // جديد: إذا للخيار أيقونة نعرضها معه
                    if let optionIcon = optionIcons[option] {
                        Label(option, systemImage: optionIcon).tag(option)
                    } else {
                        Text(option).tag(option)
                    }
                }
            }
            .pickerStyle(.menu)
            .accentColor(.gray)
        }
        .padding()
    }
}
