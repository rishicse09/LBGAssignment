//
//  MovieDetailVCDataFillExtension.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 29/03/22.
//

import Foundation
extension MovieDetailViewController {

    func setMovieDetails() {
        resetAllFields()
        movieImageView.imageURL = movieDetail?.thumbnailURL
        if let trackName = movieDetail?.trackName {
            let attributedTrackName = String().getTitleAndTextAttributedString(titleString: Constants.MovieDetailViewTitles.TRACK_NAME, textString: trackName, fontSize: 24)
            headerLabel.attributedText = attributedTrackName
        }
        if let artistName = movieDetail?.artistName {
            let attributedArtistName = String().getTitleAndTextAttributedString(titleString: Constants.MovieDetailViewTitles.ARTIST_NAME, textString: artistName)
            subHeadingLabel.attributedText = attributedArtistName
        }
        if let censoredNwme = movieDetail?.censoredName {
            let attributedCensoredName = String().getTitleAndTextAttributedString(titleString: Constants.MovieDetailViewTitles.CENSORED_NAME, textString: censoredNwme)
            censoredNameLabel.attributedText = attributedCensoredName
        }
        if let country = movieDetail?.country {
            let attributedCountry = String().getTitleAndTextAttributedString(titleString: Constants.MovieDetailViewTitles.COUNTRY, textString: country)
            countryLabel.attributedText = attributedCountry
        }
        if let trackPrice = movieDetail?.trackPrice {
            let attributedTrackPrice = String().getTitleAndTextAttributedString(titleString: Constants.MovieDetailViewTitles.TRACK_PRICE, textString: trackPrice)
            trackPriceLabel.attributedText = attributedTrackPrice
        }
        if let collectionPrice = movieDetail?.collectionPrice {
            let attributedCollectionPrice = String().getTitleAndTextAttributedString(titleString: Constants.MovieDetailViewTitles.COLLECTION_PRICE, textString: collectionPrice)
            collectionPriceLabel.attributedText = attributedCollectionPrice
        }
    }

    private func resetAllFields() {
        headerLabel.text =  ""
        subHeadingLabel.text = ""
        movieImageView.image = nil
        censoredNameLabel.text =  ""
        countryLabel.text = ""
        trackPriceLabel.text = ""
        collectionPriceLabel.text = ""
    }
}
