//
//  MovieListRow.swift
//  MovieTime
//
//  Created by arconsis on 29.04.21.
//  Copyright © 2021 arconsis. All rights reserved.
//

import SwiftUI

struct MovieListRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                 
                if let desc = movie.overview {
                    Text(desc)
                        .lineLimit(2)
                        .font(.caption)
                }

            }
            Spacer()
        }.padding()
        
        
    }
}

struct MovieListRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieListRow(movie: Movie.preview.first!)
    }
}
