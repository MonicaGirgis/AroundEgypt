//
//  ExperienceDetails.swift
//  AroundEgypt
//
//  Created by Monica Girgis Kamel on 25/03/2023.
//

import SwiftUI
import Kingfisher

struct ExperienceDetails: View {
    var experience: Experience
        
        var body: some View {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        KFImage(URL(string: experience.coverPhoto ?? "")!)
                        
                        VStack {
                            HStack {
                                Text(experience.title ?? "")
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .padding(.vertical, 0)
                            }
//                            .frame(maxWidth: .infinity)
                            Text(experience.address ?? "")
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .foregroundColor(Color.primary.opacity(0.9))
                                .padding(.bottom, 25)
//                                .listRowInsets(EdgeInsets())
                            Spacer()
                            
                            Text("Description")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            
                            Text(experience.detailedDescription ?? "")
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .foregroundColor(Color.primary.opacity(0.9))
                                .padding(.bottom, 25)
//                                .listRowInsets(EdgeInsets())
                        }
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                    .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          maxHeight: .infinity,
                          alignment: .topLeading
                        )
                    
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
}

struct ExperienceDetails_Previews: PreviewProvider {
    static let experience = Experience(id: nil, title: nil, coverPhoto: nil, description: nil, viewsNo: nil, likesNo: nil, recommended: nil, isLiked: nil, detailedDescription: nil, address: nil)
    
    static var previews: some View {
        ExperienceDetails(experience: experience)
    }
}
