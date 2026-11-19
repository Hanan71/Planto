//
//  AddPlantView.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 01/06/1448 AH.
//

import SwiftUI

struct AddPlantView: View {
    @EnvironmentObject var viewModel: PlantViewModel
    @Environment(\.dismiss) private var dismiss

    // متغير يحدد هل هي إضافة جديدة (false) أم تعديل نبتة (true)
    var isEditing: Bool = false

    // النبتة المراد تعديلها (nil = إضافة جديدة)
    var plantToEdit: PlantItem? = nil

    @State private var plantName: String = ""
    // تغيير: بدل String صارت enums (Room / LightLevel / WateringFrequency / WaterAmount)
    @State private var selectedRoom: Room = .bedroom
    @State private var selectedLight: LightLevel = .fullSun
    @State private var wateringDays: WateringFrequency = .everyDay
    @State private var waterAmount: WaterAmount = .ml20to50

    // نعبي الحقول ببيانات النبتة إذا كنا في وضع التعديل
    init(isEditing: Bool = false, plantToEdit: PlantItem? = nil) {
        self.isEditing = isEditing || plantToEdit != nil
        self.plantToEdit = plantToEdit
        _plantName = State(initialValue: plantToEdit?.name ?? "")
        _selectedRoom = State(initialValue: plantToEdit?.room ?? .bedroom)
        _selectedLight = State(initialValue: plantToEdit?.light ?? .fullSun)
        _wateringDays = State(initialValue: plantToEdit?.frequency ?? .everyDay)
        _waterAmount = State(initialValue: plantToEdit?.waterAmount ?? .ml20to50)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // حقل إدخال اسم النبتة
                        HStack {
                            Text("Plant Name")
                                .foregroundColor(.white)
                                .font(.subheadline)

                            TextField("Pothos", text: $plantName)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding()
                        // Liquid Glass
                        .glassEffect(.regular, in: .rect(cornerRadius: 16))
                        .padding(.horizontal, 20)

                        // خيارات الغرفة والإضاءة
                        VStack(spacing: 0.5) {
                            PickerRow(icon: "paperplane", title: "Room", selection: $selectedRoom, options: Room.allCases)
                            Divider().background(Color.gray.opacity(0.3))
                            // أيقونة الإضاءة تجي من LightLevel.icon
                            PickerRow(icon: "sun.max", title: "Light", selection: $selectedLight, options: LightLevel.allCases, optionIcon: { $0.icon })
                        }
                        // Liquid Glass
                        .glassEffect(.regular, in: .rect(cornerRadius: 16))
                        .padding(.horizontal, 20)

                        // خيارات أيام الري والماء
                        VStack(spacing: 0.5) {
                            PickerRow(icon: "drop", title: "Watering Days", selection: $wateringDays, options: WateringFrequency.allCases)
                            Divider().background(Color.gray.opacity(0.3))
                            PickerRow(icon: "drop.fill", title: "Water", selection: $waterAmount, options: WaterAmount.allCases)
                        }
                        // Liquid Glass
                        .glassEffect(.regular, in: .rect(cornerRadius: 16))
                        .padding(.horizontal, 20)

                        // زر الحذف يظهر فقط في وضع التعديل
                        if isEditing {
                            Button(action: {
                                // حذف النبتة فعلياً
                                if let plant = plantToEdit {
                                    viewModel.deletePlant(id: plant.id)
                                }
                                dismiss()
                            }) {
                                Text("Delete Reminder")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                            }
                            // Liquid Glass
                            .buttonStyle(.glass)
                            .buttonBorderShape(.capsule)
                            .controlSize(.large)
                            .tint(.red)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            // ملاحظة: حذفنا toolbarBackground عشان شريط التنقل يظهر بتأثير Liquid Glass
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                // زر الإغلاق (X)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .close) {
                        // التحويل لـ NoReminders فقط عند الإضافة، مو التعديل
                        if !isEditing {
                            viewModel.skipToEmptyState()
                        }
                        dismiss()
                    }
                    .tint(.primary)
                }

                // زر الحفظ (Checkmark) - زر واحد فقط
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .confirm) {
                        // إذا تعديل نحدّث النبتة، وإذا إضافة نضيفها
                        if let plant = plantToEdit {
                            viewModel.updatePlant(id: plant.id,
                                                  name: plantName,
                                                  room: selectedRoom,
                                                  light: selectedLight,
                                                  water: waterAmount,
                                                  frequency: wateringDays)
                        } else {
                            viewModel.addPlant(name: plantName,
                                               room: selectedRoom,
                                               light: selectedLight,
                                               water: waterAmount,
                                               frequency: wateringDays)
                            // الإشعار التجريبي (بعد 5 ثواني) - باقي كما هو
                            NotificationManager.shared.schedulePlantNotification(
                                plantName: plantName.isEmpty ? "plant" : plantName)
                        }
                        dismiss()
                    }
                    .tint(Color(red: 0.2, green: 0.5, blue: 0.4))
                }
            }
        }
    }
}

#Preview {
    AddPlantView(isEditing: false)
        .environmentObject(PlantViewModel())
}
