//
//  AuthService.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 15.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

protocol AuthService {

    func login(completion: @escaping (Result<Void, Error>) -> Void)
    func authCheck(completion: @escaping (Result<Bool, Error>) -> Void)
}
