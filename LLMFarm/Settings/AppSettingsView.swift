//
//  AppSettingsView.swift
//  LLMFarm
//
//  Created by guinmoon on 01.11.2023.
//

import SwiftUI

struct AppSettingsView: View {
    @EnvironmentObject var fineTuneModel: FineTuneModel
    @Binding var current_detail_view_name: String?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                DarkGradientBackground()
                    .edgesIgnoringSafeArea(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Models")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Explore a variety of on-device language models. Download and try different models to find the perfect fit for your needs.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 10)
                }
                .padding()
            }
            .frame(height: 150)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Current Models Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Models")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                        
                        ModelsView("models")
                    }
                    .padding(.horizontal)
                    
                    // Download Models Section  
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Download Models")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        DownloadModelsView()
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .background(Color(.systemBackground))
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView(current_detail_view_name: .constant(nil))
            .environmentObject(FineTuneModel())
    }
}
