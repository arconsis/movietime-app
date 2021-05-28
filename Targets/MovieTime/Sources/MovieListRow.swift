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
            if let url = movie.posterUrl {
                RemoteImage(url: url)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 100)
                
                    
            }
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                
                if let desc = movie.overview {
                    Text(desc)
                        .lineLimit(5)
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
