# MicroplaneModelsExamples

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Examples and MaterialTestUtils adapter for MicroplaneModels.

## Description

This package provides:
- Adapter to make `MicroplaneMaterial` work with the `MaterialTestUtils` interface
- Example scripts for testing various microplane models

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/sunhh/MicroplaneModelsExamples.jl")
```

## Usage

```julia
using MicroplaneModelsExamples
using MicroplaneModels
using MaterialTestUtils

# Create a microplane material
material = MicroplaneMaterial(Elastic{Float64}(), 42)

# Get initial state using MaterialTestUtils interface
state = initial_material_state(material)

# Compute stress and tangent
ε = rand(SymmetricTensor{2,3})
σ, C = compute_stress_tangent(ε, material, state)
```

## Examples

The `examples/` directory contains test scripts for different microplane models:

- `elastic/` - Elastic material model
- `elastic_damage/` - Elastic-damage material model
- `mc/` - Microplane Mohr-Coulomb model
- `mc_cap/` - Microplane Mohr-Coulomb with cap model
- `mc_damage/` - Microplane Mohr-Coulomb with damage model

Each example includes uniaxial and triaxial test simulations.

## Requirements

- Julia 1.10 or later
- MicroplaneModels.jl
- MaterialTestUtils.jl
- Tensors.jl

## Author

sunhh

## License

MIT License
