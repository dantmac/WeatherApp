//
//  TypeAlias.swift
//  WeatherApp
//
//  Created by admin on 18.08.2021.
//

typealias RequestResult<Type> = (Result<Type, Error>) -> Void
typealias ResponseModels = (DetailViewModelProtocol, HourlyCellViewModel, DailyCellViewModel)
