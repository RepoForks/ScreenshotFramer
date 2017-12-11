//
//  Operations.swift
//  FrameMe
//
//  Created by Patrick Kladek on 11.12.17.
//  Copyright © 2017 Patrick Kladek. All rights reserved.
//

import Foundation


protocol OperationProtocol {

    func apply()
}

final class UpdateFrameOperation: OperationProtocol {

    let layerStateHistory: LayerStateHistory
    let indexOfLayer: Int
    let frame: CGRect

    init(layerStateHistory: LayerStateHistory, frame: CGRect, indexOfLayer: Int) {
        self.layerStateHistory = layerStateHistory
        self.frame = frame
        self.indexOfLayer = indexOfLayer
    }

    func apply() {
        let lastLayerState = self.layerStateHistory.currentLayerState
        guard let newLayerState = lastLayerState.updating(frame: self.frame, index: self.indexOfLayer) else { return }

        self.layerStateHistory.append(newLayerState)
    }
}


final class UpdateTitleOperation: OperationProtocol {

    let layerStateHistory: LayerStateHistory
    let indexOfLayer: Int
    let title: String


    init(layerStateHistory: LayerStateHistory, title: String, indexOfLayer: Int) {
        self.layerStateHistory = layerStateHistory
        self.title = title
        self.indexOfLayer = indexOfLayer
    }

    func apply() {
        let lastLayerState = self.layerStateHistory.currentLayerState
        guard let newLayerState = lastLayerState.updating(title: self.title, index: self.indexOfLayer) else { return }

        self.layerStateHistory.append(newLayerState)
    }
}

final class AddLayerOperation: OperationProtocol {

    let layerStateHistory: LayerStateHistory

    init(layerStateHistory: LayerStateHistory) {
        self.layerStateHistory = layerStateHistory
    }

    func apply() {
        let layer = LayoutableObject()
        let newLayerState = self.layerStateHistory.currentLayerState.addingLayer(layer)
        self.layerStateHistory.append(newLayerState)
    }
}

final class RemoveLayerOperation: OperationProtocol {

    let layerStateHistory: LayerStateHistory
    let indexOfLayer: Int

    init(layerStateHistory: LayerStateHistory, indexOfLayer: Int) {
        self.layerStateHistory = layerStateHistory
        self.indexOfLayer = indexOfLayer
    }

    func apply() {
        let layers = self.layerStateHistory.currentLayerState.layers
        guard self.indexOfLayer < layers.count else { return }

        let layer = layers[self.indexOfLayer]
        let newLayerState = self.layerStateHistory.currentLayerState.removingLayer(layer)
        self.layerStateHistory.append(newLayerState)
    }
}
