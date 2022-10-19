//
//  MovieCollectionElement.swift
//  MovieTime
//
//  Created by Jonas Stubenrauch on 06.05.22.
//  Copyright © 2022 arconsis. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct MovieCollectionElement: View {
    let store: StoreOf<MovieListEntry>
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading) {
                    if let url =  viewStore.movie.posterThumbnail {
                        RemoteImage(url: url)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 180)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    Text(viewStore.movie.title)
                        .font(.caption2)
                        .bold()
                        .lineLimit(3)
                    
                    if let date = viewStore.movie.releaseDate {
                        Text(date, formatter: MovieCollectionElement.dateFormatter)
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.top, 8)
                    }
                    Spacer()
                }
                
                Image(systemName: viewStore.isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.purple)
                    .onTapGesture {
                        viewStore.send(.toggleFavorite)
                    }.padding(4)

            }
            .padding()
            .onTapGesture {
                viewStore.send(.showDetails(true))
            }
            .sheet(isPresented: viewStore.binding(get: \.isDetailShown, send: MovieListEntry.Action.showDetails)) {
                IfLetStore(
                    store.scope(
                        state: \.detail,
                        action: MovieListEntry.Action.detail),
                    then: {
                        MovieDetailScreen(store:$0)
                    })
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
        .frame(width: 120)
    }
}



//import MovieApi
//struct MovieCollectionElement_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieCollectionView(store: .init(
//            initialState: .init(type: <#T##MovieCollection.State.CollectionType#>, currentPage: <#T##Int#>, lastPageReached: <#T##Bool#>, isLoadingMoreMovies: <#T##Bool#>, loadingMoreFailed: <#T##Bool#>, movieStates: <#T##IdentifiedArrayOf<MovieListEntry.State>#>)
//                    .init(
//                movie: Movie.preview.first!,
//                isFavorite: true,
//                isDetailShown: false,
//                detail: nil),
//            reducer: MovieCollection()))
//    }
//}
