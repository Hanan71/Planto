//
//  StartView.swift
//  Plant Task
//

import SwiftUI

struct StartView: View {
    // متغير حالة لفتح شاشة إضافة التنبيه
    @State private var showingAddPlant = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 16) {
                HStack {
                    Text("My Plants 🌱")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 0)

                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal, 20)

                // مسافة رفع الصورة للأعلى
                Spacer().frame(height: 30)

                Image("plant_placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .padding(.leading, 0)

                // 💡 أضفنا هذه المسافة هنا لتحت الصورة وتنزيل الكلام شوي عن
                Spacer().frame(height: 20)

                VStack(spacing: 8) {
                    Text("Start your plant journey!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                // زر الانتقال لشاشة Set Reminder (Liquid Glass)
                Button(action: {
                    showingAddPlant = true
                }) {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .glassEffect(
                            .regular
                                .tint(Color(red: 0.2, green: 0.5, blue: 0.4))
                                .interactive(),
                            in: .capsule
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 32)
                .padding(.bottom, 160)
            }
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView()
        }
        // طلب الإذن بالإشعارات أول ما تظهر الشاشة
        .onAppear {
            NotificationManager.shared.requestPermission()
        }
    }
}

#Preview {
    StartView()
        .environmentObject(PlantViewModel())
}
